//
//  HistoryViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import QuickLook
import Toast
import ApphudSDK

class HistoryViewController: BaseViewController {

    var viewModel: ViewModel?
    private let header = UILabel(text: "Last",
                                 textColor: UIColor.black,
                                 font: UIFont(name: "SFProText-Bold", size: 18))
    var collectionView: UICollectionView!
    private var currentPreviewItem: URL?

    var style = ToastStyle()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleUpdateNotification(_:)),
            name: Notification.Name("HistoryUpdated"),
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.loadFiles()
        self.collectionView.reloadData()

        setupNavigationItems()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        self.header.textAlignment = .left

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 343, height: 65)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(FileCollectionViewCell.self)
        collectionView.register(EmptyCollectionViewCelll.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.insetsLayoutMarginsFromSafeArea = false

        style.messageColor = UIColor(hex: "#F9F9F9")!
        style.backgroundColor = UIColor(hex: "#22242C")!

        self.view.addSubview(header)
        self.view.addSubview(collectionView)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
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
    }

}

//MARK: Make buttons actions
extension HistoryViewController {
    
    private func makeButtonsAction() {
        
    }
    
    @objc func openSettings() {
        guard let navigationController = self.navigationController else { return }
        
        MainRouter.showSettingsViewController(in: navigationController)
    }
    
    private func setupNavigationItems() {
        if !Apphud.hasActiveSubscription() {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "getPro"), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 110, height: 32)
            button.addTarget(self, action: #selector(getProSubscription), for: .touchUpInside)

            let proButton = UIBarButtonItem(customView: button)
            navigationItem.rightBarButtonItem = proButton
        }

        let button1 = UIButton(type: .custom)
        button1.setImage(UIImage(named: "mainSetttings"), for: .normal)
        button1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button1.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        let leftButton = UIBarButtonItem(customView: button1)
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func getProSubscription() {
        guard let navigationController = self.navigationController else { return }

        MainRouter.showPaymentViewController(in: navigationController)
    }
    
    private func setPageToMain() {
        NotificationCenter.default.post(name: Notification.Name("setPageToMain"), object: nil, userInfo: nil)
    }
    
    private func deletePDF(by index: Int) {
        guard let id = self.viewModel?.savedFiles[index].id else { return }

        self.viewModel?.deleteSavedFile(by: id)
        self.viewModel?.loadFiles()
        self.collectionView.reloadData()
    }

    private func share(by index: Int) {
        guard let pdfURL = self.viewModel?.savedFiles[index].fileURL else { return }

        let activityViewController = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)

        if let popoverController = activityViewController.popoverPresentationController,
           let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            popoverController.sourceView = window
            popoverController.sourceRect = CGRect(x: window.frame.width / 2,
                                                  y: window.frame.height,
                                                  width: 0,
                                                  height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(activityViewController, animated: true)
    }

    private func preview(by index: Int) {
        guard let pdfURL = self.viewModel?.savedFiles[index].fileURL else { return }
        currentPreviewItem = pdfURL

        let previewController = QLPreviewController()
        previewController.dataSource = self
        present(previewController, animated: true, completion: nil)
    }

    private func openActionSheet(with indexPath: IndexPath, and collectionView: UICollectionView) {
        let alert = UIAlertController(title: "Select Variant", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Preview", style: .default) { _ in
            self.preview(by: indexPath.row)
        })

        alert.addAction(UIAlertAction(title: "To another format", style: .default) { _ in
            self.setPageToMain()
        })
    
        alert.addAction(UIAlertAction(title: "Share", style: .default) { _ in
            self.share(by: indexPath.row)
        })

        alert.addAction(UIAlertAction(title: "Download", style: .default) { _ in
            self.share(by: indexPath.row)
        })

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deletePDF(by: indexPath.row)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let popoverController = alert.popoverPresentationController {
            if let cell = collectionView.cellForItem(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }

        present(alert, animated: true, completion: nil)
    }

    @objc func handleUpdateNotification(_ notification: Notification) {
        self.view.makeToast("The conversion you created is already available, please refresh this page..", duration: 2.0, position: .bottom)
    }
}

extension HistoryViewController: IViewModelableController {
    typealias ViewModel = IHistoryViewModel
}

//MARK: Collection view delegate
extension HistoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.savedFiles.isEmpty ?? true ? 1 : self.viewModel!.savedFiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.viewModel?.savedFiles.isEmpty ?? true {

            self.header.isHidden = true

            let cell: EmptyCollectionViewCelll = collectionView.dequeueReusableCell(for: indexPath)

            cell.addSubject.sink { [weak self] _ in
                self?.setPageToMain()
            }.store(in: &cell.cancellables)

            return cell
        } else {
            self.header.isHidden = false

            let cell: FileCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

            if let model = self.viewModel?.savedFiles[indexPath.row] {
                cell.configure(model: model)
            }

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.viewModel?.savedFiles.isEmpty ?? true {
            return
        }

        let model = self.viewModel?.savedFiles[indexPath.row]

        guard let password = model?.password, model?.password != nil else {
            openActionSheet(with: indexPath, and: collectionView)
            return
        }

        let alertController = UIAlertController(title: "Enter Password", message: "This file is protected", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
        }

        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let enteredPassword = alertController.textFields?.first?.text {
                if enteredPassword == password {
                    self.openActionSheet(with: indexPath, and: collectionView)
                } else {
                    let errorAlert = UIAlertController(title: "Incorrect Password", message: "The password you entered is incorrect.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(errorAlert, animated: true)
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.viewModel?.savedFiles.isEmpty ?? true {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: 343, height: 65)
        }
    }
}

extension HistoryViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return currentPreviewItem! as QLPreviewItem
    }
}

//MARK: Preview
import SwiftUI

struct HistoryViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let historyViewController = HistoryViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<HistoryViewControllerProvider.ContainerView>) -> HistoryViewController {
            return historyViewController
        }

        func updateUIViewController(_ uiViewController: HistoryViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<HistoryViewControllerProvider.ContainerView>) {
        }
    }
}
