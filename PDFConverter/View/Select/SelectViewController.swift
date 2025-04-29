//
//  SelectViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import PDFConverterModel
import UniformTypeIdentifiers

class SelectViewController: BaseViewController {

    var viewModel: ViewModel?
    private let header = UILabel(text: "Select file",
                                 textColor: UIColor.black,
                                 font: UIFont(name: "SFProText-Bold", size: 18))
    var collectionView: UICollectionView!
    private let nextButton = UIButton(type: .system)

    private var selectedIndex: IndexPath?
    private var selectedFile: SavedFilesModel?

    private var collectionViewDataSource: [SavedFilesModel] = []

    private var conversionType: PDFType?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        self.header.textAlignment = .left

        self.nextButton.setTitle("Next", for: .normal)
        self.nextButton.setTitleColor(.white, for: .normal)
        self.nextButton.layer.cornerRadius = 12
        self.nextButton.layer.masksToBounds = true
        self.nextButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 343, height: 65)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(SelectEmptyCollectionViewCell.self)
        collectionView.register(SelectFileCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.insetsLayoutMarginsFromSafeArea = false

        let buttonGradient = CAGradientLayer()
        buttonGradient.colors = [
            UIColor(hex: "#232120")!.cgColor,
            UIColor(hex: "#565150")!.cgColor,
            UIColor(hex: "#89817F")!.cgColor
        ]
        buttonGradient.startPoint = CGPoint(x: 0, y: 0.5)
        buttonGradient.endPoint = CGPoint(x: 1, y: 0.5)
        buttonGradient.locations = [0.0, 0.5, 1.0]
        buttonGradient.cornerRadius = 20
        nextButton.layer.insertSublayer(buttonGradient, at: 0)

        self.view.addSubview(header)
        self.view.addSubview(collectionView)
        self.view.addSubview(nextButton)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()

        self.viewModel?.loadFiles()

        self.conversionType = self.viewModel?.type

        if let savedFiles = self.viewModel?.savedFiles {
            self.collectionViewDataSource = savedFiles.filter { file in
                let expectedType = self.conversionType

                let ext = file.fileURL.pathExtension.lowercased()
                return isSupportedExtension(for: expectedType!, fileExtension: ext)
            }
            self.collectionView.reloadData()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let gradientLayer = nextButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = nextButton.bounds
        }
    }

    func setupConstraints() {

        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(125)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(20)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview()
        }

        nextButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(50)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(44)
        }
    }

}

//MARK: Make buttons actions
extension SelectViewController {
    
    private func makeButtonsAction() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    private func isSupportedExtension(for type: PDFType, fileExtension: String) -> Bool {
        switch type {
        case .wordToPDF:
            return ["doc", "docx"].contains(fileExtension)
        case .exelToPDF:
            return ["xls", "xlsx"].contains(fileExtension)
        case .imageToPDF:
            return ["jpg", "jpeg", "png", "heic"].contains(fileExtension)
        case .pdf, .textToImage, .split, .pdfToDoc, .signature:
            return fileExtension == "pdf"
        case .pointToPdf:
            return ["ppt", "pptx"].contains(fileExtension)
        case .pngToPdf:
            return fileExtension == "png"
        case .jpegToPDF:
            return ["jpeg", "jpg"].contains(fileExtension)
        }
    }

    private func uploadWithType() {
        guard let conversionType = self.conversionType else { return }

        let supportedTypes: [UTType]

        switch conversionType {
        case .wordToPDF:
            supportedTypes = [UTType(filenameExtension: "doc")!, UTType(filenameExtension: "docx")!]
        case .exelToPDF:
            supportedTypes = [UTType(filenameExtension: "xls")!, UTType(filenameExtension: "xlsx")!]
        case .pdf, .split, .pdfToDoc, .textToImage, .signature:
            supportedTypes = [UTType.pdf]
        case .pointToPdf:
            supportedTypes = [UTType(filenameExtension: "ppt")!, UTType(filenameExtension: "pptx")!]
        case .pngToPdf:
            supportedTypes = [UTType.png]
        case .jpegToPDF:
            supportedTypes = [UTType.jpeg, UTType(filenameExtension: "jpg")!]
        case .imageToPDF:
            supportedTypes = [UTType.jpeg, UTType(filenameExtension: "jpg")!, UTType.png]
        }
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }

    @objc func nextButtonTapped() {
        guard let navigationController = self.navigationController else { return }
        guard let type = self.conversionType else { return }
        guard let pdfURl = self.selectedFile?.fileURL else {
            self.showBadAlert(message: "Please select one of the existing files or add a new file before proceeding to the next page.")
            return
        }
        guard let selectedFile = self.selectedFile else { return }

        switch type {
        case .wordToPDF:
            print("wordToPDF")
        case .imageToPDF:
            if let imageURL = convertImageURLToPDF(pdfURl) {
                self.viewModel?.addSavedFile(.init(pdfURL: imageURL, type: .imageToPDF))
                self.showSuccessAlert(message: "Your image has been converted to pdf and saved. Check it in the 'History' section.") {
                    if let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate {
                        sceneDelegate.startTabBarFlow()
                    }
                }
            }
        case .exelToPDF:
            print("exelToPDF")
        case .pdf:
            SelectRouter.showPasswordViewController(in: navigationController,
                                                    navigationModel: .init(model: selectedFile))
        case .pointToPdf:
            print("pointToPdf")
        case .split:
            SelectRouter.showSplitViewController(in: navigationController,
                                                navigationModel: .init(pdfURL: pdfURl))
        case .pdfToDoc:
            print("pdfToDoc")
        case .textToImage:
            SelectRouter.showTextViewController(in: navigationController,
                                                navigationModel: .init(pdfURL: pdfURl))
        case .pngToPdf:
            if let imageURL = convertImageURLToPDF(pdfURl) {
                self.viewModel?.addSavedFile(.init(pdfURL: imageURL, type: .pngToPdf))
                self.showSuccessAlert(message: "Your image has been converted to pdf and saved. Check it in the 'History' section.") {
                    if let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate {
                        sceneDelegate.startTabBarFlow()
                    }
                }
            }
        case .signature:
            SelectRouter.showSignatureViewController(in: navigationController,
                                                     navigationModel: .init(pdfURL: pdfURl))
        case .jpegToPDF:
            if let imageURL = convertImageURLToPDF(pdfURl) {
                self.viewModel?.addSavedFile(.init(pdfURL: imageURL, type: .jpegToPDF))
                self.showSuccessAlert(message: "Your image has been converted to pdf and saved. Check it in the 'History' section.") {
                    if let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate {
                        sceneDelegate.startTabBarFlow()
                    }
                }
            }
        }
    }

    @objc func plusFile() {
        let alert = UIAlertController(title: "Select Variant", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Upload from device", style: .default) { _ in
            self.uploadWithType()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true, completion: nil)
    }

    @objc func customBackFunctionality() {
        guard let navigationController = self.navigationController else { return }

        SelectRouter.popViewController(in: navigationController)
    }

    private func setupNavigationItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "plusFileButton"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.addTarget(self, action: #selector(plusFile), for: .touchUpInside)

        let button1 = UIButton(type: .custom)
        button1.setImage(UIImage(named: "ntfBack"), for: .normal)
        button1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button1.addTarget(self, action: #selector(customBackFunctionality), for: .touchUpInside)

        let rightButton = UIBarButtonItem(customView: button)
        let leftButton = UIBarButtonItem(customView: button1)

        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton

    }

    func convertImageURLToPDF(_ imageUrl: URL) -> URL? {
        if let image = UIImage(contentsOfFile: imageUrl.path) {
            return image.toPDF()
        } else {
            print("Path error: \(imageUrl)")
            return nil
        }
    }

}

extension SelectViewController: IViewModelableController {
    typealias ViewModel = ISelectViewModel
}

//MARK: Collection view delegate
extension SelectViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewDataSource.isEmpty ? 1 : self.collectionViewDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.collectionViewDataSource.isEmpty {

            self.header.isHidden = true

            let cell: SelectEmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        } else {
            self.header.isHidden = false

            let cell: SelectFileCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

            cell.updateSelectionState(isSelected: indexPath == selectedIndex)

            let model = self.collectionViewDataSource[indexPath.row]
            cell.configure(model: model)

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndex = selectedIndex,
           let previousCell = collectionView.cellForItem(at: previousIndex) as? SelectFileCollectionViewCell {
            previousCell.updateSelectionState(isSelected: false)
        }

        selectedIndex = indexPath
        selectedFile = self.collectionViewDataSource[indexPath.row]

        if let newCell = collectionView.cellForItem(at: indexPath) as? SelectFileCollectionViewCell {
            newCell.updateSelectionState(isSelected: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.collectionViewDataSource.isEmpty {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: 343, height: 65)
        }
    }
}

extension SelectViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }

        let newSavedFile = SavedFilesModel(id: UUID().hashValue,
                                           pdfURL: url,
                                           type: self.conversionType ?? .pdf)
        self.collectionViewDataSource.append(newSavedFile)
        self.collectionView.reloadData()
    }
}

//MARK: Preview
import SwiftUI

struct SelectViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let selectViewController = SelectViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<SelectViewControllerProvider.ContainerView>) -> SelectViewController {
            return selectViewController
        }

        func updateUIViewController(_ uiViewController: SelectViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SelectViewControllerProvider.ContainerView>) {
        }
    }
}
