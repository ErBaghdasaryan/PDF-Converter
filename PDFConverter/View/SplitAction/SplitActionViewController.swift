//
//  SplitActionViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 29.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import StoreKit
import PDFKit

class SplitActionViewController: BaseViewController {

    var viewModel: ViewModel?

    private let totalPages = UILabel(text: "",
                                textColor: UIColor(hex: "#5F6E85")!,
                                font: UIFont(name: "SFProText-Regular", size: 16))
    private let from = CustomTextView(placeholder: "From")
    private let to = CustomTextView(placeholder: "To")
    private var fieldsStack: UIStackView!

    private let splitButton = UIButton(type: .system)

    private var document: PDFDocument?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        self.totalPages.textAlignment = .left

        self.fieldsStack = UIStackView(arrangedSubviews: [from, to],
                                       axis: .horizontal,
                                       spacing: 16)
        self.fieldsStack.distribution = .fillEqually

        self.splitButton.setTitle("Split", for: .normal)
        self.splitButton.setTitleColor(.white, for: .normal)
        self.splitButton.layer.cornerRadius = 12
        self.splitButton.layer.masksToBounds = true
        self.splitButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)

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
        splitButton.layer.insertSublayer(buttonGradient, at: 0)

        self.view.addSubview(totalPages)
        self.view.addSubview(fieldsStack)
        self.view.addSubview(splitButton)
        setupConstraints()
        setupNavigationItems()
        self.setupViewTapHandling()
        setupTextFieldDelegates()
    }

    override func setupViewModel() {
        super.setupViewModel()

        if let pdfURL = self.viewModel?.pdfURL {
            if let document = PDFDocument(url: pdfURL) {
                self.document = document
                self.totalPages.text = "Total pages: \(document.pageCount)"
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let gradientLayer = splitButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = splitButton.bounds
        }
    }

    func setupConstraints() {
        totalPages.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(124)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(18)
        }

        fieldsStack.snp.makeConstraints { view in
            view.top.equalTo(totalPages.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(40)
        }

        splitButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(50)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(44)
        }
    }

}

//MARK: Make buttons actions
extension SplitActionViewController {
    
    private func makeButtonsAction() {
        splitButton.addTarget(self, action: #selector(splitButtonAction), for: .touchUpInside)
    }

    @objc func splitButtonAction() {
        guard let type = self.viewModel?.action else { return }
        guard let fromText = self.from.text, let toText = self.to.text,
            let from = Int(fromText), let to = Int(toText) else {
            self.showBadAlert(message: "Please fill in both fields before clicking the button.")
            return
        }
        guard let document = self.document else { return }

        switch type {
        case .divideByRange:
            guard document.pageCount > 1 else {
                showBadAlert(message: "Cannot split a one-page document.")
                return
            }

            guard from >= 1, to <= document.pageCount, from <= to else {
                showBadAlert(message: "Invalid page range.")
                return
            }

            if let newDoc = extractPages(from: from, to: to, from: document),
               let url = savePDFDocument(newDoc, fileName: "split_range_\(UUID().uuidString).pdf") {

                self.viewModel?.addSavedFile(.init(pdfURL: url, type: .split))

                self.showSuccessAlert(message: "Your extracted pdf has been saved. Check it in the 'History' section.") {
                    if let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate {
                        sceneDelegate.startTabBarFlow()
                    }
                }
            }
        case .fixedRange:
            guard document.pageCount > 1 else {
                showBadAlert(message: "Cannot split a one-page document into parts.")
                return
            }

            if let doc = splitFixedRange(document: document, pagesPerDoc: to),
               let url = savePDFDocument(doc, fileName: "split_range_\(UUID().uuidString).pdf") {

                self.viewModel?.addSavedFile(.init(pdfURL: url, type: .split))

                self.showSuccessAlert(message: "Your extracted pdf has been saved. Check it in the 'History' section.") {
                    if let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate {
                        sceneDelegate.startTabBarFlow()
                    }
                }
            }

        case .deletePages:
            let indicesToDelete = Array((from...to)).map { $0 - 1 }

            guard document.pageCount - indicesToDelete.count > 0 else {
                showBadAlert(message: "You cannot delete all pages from the document.")
                return
            }

            if let newDoc = deletePages(indices: indicesToDelete, from: document),
               let url = savePDFDocument(newDoc, fileName: "split_range_\(UUID().uuidString).pdf") {

                self.viewModel?.addSavedFile(.init(pdfURL: url, type: .split))

                self.showSuccessAlert(message: "Your extracted pdf has been saved. Check it in the 'History' section.") {
                    if let sceneDelegate = UIApplication.shared.connectedScenes
                        .first?.delegate as? SceneDelegate {
                        sceneDelegate.startTabBarFlow()
                    }
                }
            }
        }
    }

    private func setupNavigationItems() {
        let button1 = UIButton(type: .custom)
        button1.setImage(UIImage(named: "ntfBack"), for: .normal)
        button1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button1.addTarget(self, action: #selector(customBackFunctionality), for: .touchUpInside)

        let leftButton = UIBarButtonItem(customView: button1)

        navigationItem.leftBarButtonItem = leftButton
    }

    @objc func customBackFunctionality() {
        guard let navigationController = self.navigationController else { return }

        SplitActionRouter.popViewController(in: navigationController)
    }
}

extension SplitActionViewController: IViewModelableController {
    typealias ViewModel = ISplitActionViewModel
}

//MARK: Split Functionality
extension SplitActionViewController {
    func extractPages(from start: Int, to end: Int, from document: PDFDocument) -> PDFDocument? {
        let newDocument = PDFDocument()
        let pageCount = document.pageCount

        guard start >= 1, end <= pageCount, start <= end else { return nil }

        for index in (start-1)...(end-1) {
            if let page = document.page(at: index) {
                newDocument.insert(page, at: newDocument.pageCount)
            }
        }

        return newDocument
    }

    func deletePages(indices: [Int], from document: PDFDocument) -> PDFDocument? {
        let newDocument = document.copy() as! PDFDocument
        let sorted = indices.sorted(by: >)

        for index in sorted {
            if index >= 0, index < newDocument.pageCount {
                newDocument.removePage(at: index)
            }
        }

        return newDocument
    }

    func splitFixedRange(document: PDFDocument, pagesPerDoc: Int) -> PDFDocument? {
        var newDocument: PDFDocument?
        let pageCount = document.pageCount

        var startIndex = 0
        while startIndex < pageCount {
            let newDoc = PDFDocument()
            let endIndex = min(startIndex + pagesPerDoc, pageCount)
            for i in startIndex..<endIndex {
                if let page = document.page(at: i) {
                    newDoc.insert(page, at: newDoc.pageCount)
                }
            }
            newDocument = newDoc
            startIndex += pagesPerDoc
        }

        return newDocument
    }

    func savePDFDocument(_ document: PDFDocument, fileName: String) -> URL? {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)

        if document.write(to: fileURL) {
            return fileURL
        } else {
            print("❗ Не удалось сохранить PDF по пути \(fileURL)")
            return nil
        }
    }
}

//MARK: UIGesture & cell's touches
extension SplitActionViewController: UITextFieldDelegate, UITextViewDelegate {

    private func setupTextFieldDelegates() {
        self.from.delegate = self
        self.to.delegate = self

        self.from.keyboardType = .numberPad
        self.to.keyboardType = .numberPad
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.from:
            self.to.becomeFirstResponder()
        case self.to:
            self.to.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

//MARK: Preview
import SwiftUI

struct SplitActionViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let splitActionViewController = SplitActionViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<SplitActionViewControllerProvider.ContainerView>) -> SplitActionViewController {
            return splitActionViewController
        }

        func updateUIViewController(_ uiViewController: SplitActionViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SplitActionViewControllerProvider.ContainerView>) {
        }
    }
}
