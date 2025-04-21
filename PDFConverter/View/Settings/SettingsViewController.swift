//
//  SettingsViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import StoreKit
//import ApphudSDK

class SettingsViewController: BaseViewController {

    var viewModel: ViewModel?
    private let header = UILabel(text: "Settings",
                                 textColor: UIColor.black,
                                 font: UIFont(name: "SFProText-Bold", size: 18))
    var collectionView: UICollectionView!

    private let terms = UIButton(type: .system)
    private let privacy = UIButton(type: .system)
    private let restore = UIButton(type: .system)
    private var buttonsStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        self.title = "Settings"

        let mylayout = UICollectionViewFlowLayout()
        mylayout.itemSize = CGSize(width: self.view.frame.width - 32, height: 52)
        mylayout.scrollDirection = .vertical
        mylayout.minimumLineSpacing = 0
        mylayout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: mylayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(NotificationCell.self)
        collectionView.register(SettingsCell.self)
        collectionView.register(VersionCell.self)
        collectionView.register(SettingsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SettingsHeaderView")
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self

        self.privacy.setTitle("Privacy policy", for: .normal)
        self.privacy.setTitleColor(UIColor(hex: "#22242C")!.withAlphaComponent(0.7), for: .normal)
        self.privacy.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)

        self.terms.setTitle("Terms of Use", for: .normal)
        self.terms.setTitleColor(UIColor(hex: "#22242C")!.withAlphaComponent(0.7), for: .normal)
        self.terms.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)

        self.restore.setTitle("Restore purchases", for: .normal)
        self.restore.setTitleColor(UIColor(hex: "#22242C")!.withAlphaComponent(0.7), for: .normal)
        self.restore.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 12)

        self.buttonsStack = UIStackView(arrangedSubviews: [terms,
                                                           restore,
                                                           privacy],
                                        axis: .horizontal,
                                        spacing: 0)
        self.buttonsStack.distribution = .fillEqually

        self.view.addSubview(header)
        self.view.addSubview(collectionView)
        self.view.addSubview(buttonsStack)
        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()
        self.viewModel?.loadData()
        self.collectionView.reloadData()
    }

    func setupConstraints() {

        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(34)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(20)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(72)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview()
        }

        buttonsStack.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(42)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(14)
        }
    }

}

//MARK: Make buttons actions
extension SettingsViewController {
    
    private func makeButtonsAction() {

    }

    @objc func getProSubscription() {
        guard let navigationController = self.navigationController else { return }

//        if Apphud.hasActiveSubscription() {
//            SettingsRouter.showUpdatePaymentViewController(in: navigationController)
//        } else {
            SettingsRouter.showPaymentViewController(in: navigationController)
//        }
    }

    private func configureCorners(for cell: UICollectionViewCell, indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let itemsCount = self.viewModel?.settingsItems[section].count ?? 0

        cell.contentView.layer.cornerRadius = 0
        cell.contentView.layer.maskedCorners = []

        let bottomView = UIView()

        bottomView.backgroundColor = UIColor(hex: "#5F6E85")
        cell.contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(1)
        }

        if section == 0 {
            if row == 0 {
                cell.contentView.layer.cornerRadius = 16
                cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if row == itemsCount - 1 {
                cell.contentView.layer.cornerRadius = 16
                cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                bottomView.removeFromSuperview()
            }
        } else if section == 1 {
            if row == 0 {
                cell.contentView.layer.cornerRadius = 16
                cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if row == itemsCount - 1 {
                cell.contentView.layer.cornerRadius = 16
                cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                bottomView.removeFromSuperview()
            }
        } else if section == 2 {
            if row == 0 {
                cell.contentView.layer.cornerRadius = 16
                cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if row == itemsCount - 2 {
                cell.contentView.layer.cornerRadius = 16
                cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                bottomView.removeFromSuperview()
            } else if row == itemsCount - 1 {
                bottomView.removeFromSuperview()
            }
        }
    }

    private func calculateOverallIndex(for indexPath: IndexPath) -> Int {
        var overallIndex = 0

        for section in 0..<indexPath.section {
            overallIndex += viewModel?.settingsItems[section].count ?? 0
        }

        overallIndex += indexPath.row

        return overallIndex
    }

    private func tappedCell(from index: Int) {
        switch index {
        case 0:
            self.shareTapped()
        case 1:
            self.rateTapped()
        case 2:
            break
        case 3:
            self.getProSubscription()
        case 4:
            self.restoreTapped()
        case 5:
            self.showClearCacheAlert()
        case 6:
            self.contactUsTapped()
        case 7:
            self.privacyTapped()
        case 8:
            self.termsTapped()
        default:
            break
        }
    }

    private func showClearCacheAlert() {
        let alertController = UIAlertController(
            title: "Clear cache?",
            message: "The cached files of your videos will be deleted from your phone's memory. But your download history will be retained",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { _ in
            self.clearCache()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(clearAction)

        present(alertController, animated: true, completion: nil)
    }

    private func clearCache() {
        let fileManager = FileManager.default

        if let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            do {
                let cachedFiles = try fileManager.contentsOfDirectory(at: cachesDirectory, includingPropertiesForKeys: nil, options: [])
                for fileURL in cachedFiles {
                    try fileManager.removeItem(at: fileURL)
                }
            } catch {
                print("Error clearing cache: \(error)")
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    private func restoreTapped() {
//        guard let navigationController = self.navigationController else { return }
//        self.restorePurchase { result in
//            if result {
//                self.showSuccessAlert(message: "You have successfully restored your purchases.")
//            } else {
//                self.showBadAlert(message: "Your purchase could not be restored. Please try again later.")
//            }
//        }
    }

//    @MainActor
//    func restorePurchase(escaping: @escaping(Bool) -> Void) {
//        Apphud.restorePurchases { subscriptions, _, error in
//            if let error = error {
//                print(error.localizedDescription)
//                escaping(false)
//            }
//            if subscriptions?.first?.isActive() ?? false {
//                escaping(true)
//            }
//            if Apphud.hasActiveSubscription() {
//                escaping(true)
//            }
//        }
//    }

    private func rateTapped() {
        guard let scene = view.window?.windowScene else { return }
        if #available(iOS 14.0, *) {
            SKStoreReviewController.requestReview()
        } else {
            let alertController = UIAlertController(
                title: "Enjoying the app?",
                message: "Please consider leaving us a review in the App Store!",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Go to App Store", style: .default) { _ in
                if let appStoreURL = URL(string: "https://apps.apple.com/us/app/loud-ai-app/id6744518487") {
                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                }
            })
            present(alertController, animated: true, completion: nil)
        }
    }

    private func shareTapped() {
        let appStoreURL = URL(string: "https://apps.apple.com/us/app/loud-ai-app/id6744518487")!

        let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [
            .postToWeibo,
            .print,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .openInIBooks,
            .markupAsPDF,
            .mail,
            .airDrop,
            .postToFacebook,
            .postToTwitter,
            .copyToPasteboard
        ]

        present(activityViewController, animated: true, completion: nil)
    }

    private func contactUsTapped() {
        guard let navigationController = self.navigationController else { return }

        SettingsRouter.showContactUsViewController(in: navigationController)
    }

    private func termsTapped() {
        guard let navigationController = self.navigationController else { return }

        SettingsRouter.showTermsViewController(in: navigationController)
    }

    private func privacyTapped() {
        guard let navigationController = self.navigationController else { return }

        SettingsRouter.showPrivacyViewController(in: navigationController)
    }
}

extension SettingsViewController: IViewModelableController {
    typealias ViewModel = ISettingsViewModel
}

extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel?.sections.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.viewModel?.settingsItems[section].count ?? 0
        return self.viewModel?.settingsItems[section].count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let item = self.viewModel?.settingsItems[indexPath.section][indexPath.row] {
            let cell: UICollectionViewCell

            if item.isSwitch {
                let notificationCell: NotificationCell = collectionView.dequeueReusableCell(for: indexPath)
                notificationCell.configure(with: item)
                cell = notificationCell
            } else if item.isVersion {
                let versionCell: VersionCell = collectionView.dequeueReusableCell(for: indexPath)
                if let version = Bundle.main.releaseVersionNumber {
                    versionCell.configure(with: .init(icon: nil,
                                                      title: "Version: V\(version)",
                                                      isSwitch: false,
                                                      isVersion: true))
                }
                cell = versionCell
            } else {
                let settingsCell: SettingsCell = collectionView.dequeueReusableCell(for: indexPath)
                settingsCell.configure(with: item)
                cell = settingsCell
            }

            configureCorners(for: cell, indexPath: indexPath)

            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 52)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SettingsHeaderView", for: indexPath) as! SettingsHeaderView
            if let model = self.viewModel?.sections[indexPath.section] {
                header.configure(with: model)
                return header
            }
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 46)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let overallIndex = calculateOverallIndex(for: indexPath)
        self.tappedCell(from: overallIndex)
    }
}

//MARK: Preview
import SwiftUI

struct SettingsViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let settingsViewController = SettingsViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<SettingsViewControllerProvider.ContainerView>) -> SettingsViewController {
            return settingsViewController
        }

        func updateUIViewController(_ uiViewController: SettingsViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SettingsViewControllerProvider.ContainerView>) {
        }
    }
}
