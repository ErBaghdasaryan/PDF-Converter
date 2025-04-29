//
//  MainViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import Toast

class MainViewController: BaseViewController {

    var viewModel: ViewModel?
    var collectionView: UICollectionView!

    var style = ToastStyle()

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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        let mylayout = UICollectionViewFlowLayout()
        mylayout.itemSize = CGSize(width: 70, height: 90)
        mylayout.scrollDirection = .vertical
        mylayout.minimumLineSpacing = 12
        mylayout.minimumInteritemSpacing = 12

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: mylayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(hex: "#F9F9F9")
        collectionView.layer.masksToBounds = true
        collectionView.layer.cornerRadius = 12

        collectionView.register(MainCollectionViewCell.self)
        collectionView.register(SettingsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SettingsHeaderView")
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self

        style.messageColor = UIColor(hex: "#F9F9F9")!
        style.backgroundColor = UIColor(hex: "#22242C")!

        self.view.addSubview(collectionView)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
        self.viewModel?.loadData()
        self.collectionView.reloadData()
    }

    func setupConstraints() {
        collectionView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(124)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview()
        }
    }

}

//MARK: Make buttons actions
extension MainViewController {
    
    private func makeButtonsAction() {

    }

    private func calculateOverallIndex(for indexPath: IndexPath) -> Int {
        var overallIndex = 0

        for section in 0..<indexPath.section {
            overallIndex += viewModel?.mainItems[section].count ?? 0
        }

        overallIndex += indexPath.row

        return overallIndex
    }

    private func tappedCell(from index: Int) {
        guard let navigationController = self.navigationController else { return }
        switch index {
        case 0:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .wordToPDF))
        case 1:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .exelToPDF))
        case 2:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .pdf))
        case 3:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .imageToPDF))
        case 4:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .pointToPdf))
        case 5:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .split))
        case 6:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .wordToPDF))
        case 7:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .exelToPDF))
        case 8:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .pdf))
        case 9:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .pdfToDoc))
        case 10:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .imageToPDF))
        case 11:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .pointToPdf))
        case 12:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .split))
        case 13:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .jpegToPDF))
        case 14:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .textToImage))
        case 15:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .pngToPdf))
        case 16:
            MainRouter.showSelectViewController(in: navigationController,
                                                navigationModel: .init(type: .signature))

        default:
            break
        }
    }

    @objc func openSettings() {
        guard let navigationController = self.navigationController else { return }

        MainRouter.showSettingsViewController (in: navigationController)
    }

    private func setupNavigationItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "getPro"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 110, height: 32)
        button.addTarget(self, action: #selector(getProSubscription), for: .touchUpInside)

        let button1 = UIButton(type: .custom)
        button1.setImage(UIImage(named: "mainSetttings"), for: .normal)
        button1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button1.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        let proButton = UIBarButtonItem(customView: button)
        let leftButton = UIBarButtonItem(customView: button1)
        navigationItem.leftBarButtonItem = leftButton

        navigationItem.rightBarButtonItem = proButton

    }

    @objc func getProSubscription() {
        guard let navigationController = self.navigationController else { return }

//        if Apphud.hasActiveSubscription() {
//            SettingsRouter.showUpdatePaymentViewController(in: navigationController)
//        } else {
            MainRouter.showPaymentViewController(in: navigationController)
//        }
    }

    @objc func handleUpdateNotification(_ notification: Notification) {
        self.view.makeToast("The new conversion you created is already available in the History section.", duration: 2.0, position: .bottom)
    }
}

extension MainViewController: IViewModelableController {
    typealias ViewModel = IMainViewModel
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel?.sections.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.viewModel?.mainItems[section].count ?? 0
        return self.viewModel?.mainItems[section].count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let item = self.viewModel?.mainItems[indexPath.section][indexPath.row] {
            cell.setup(model: item)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 76, height: 95)
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

struct MainViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let mainViewController = MainViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<MainViewControllerProvider.ContainerView>) -> MainViewController {
            return mainViewController
        }

        func updateUIViewController(_ uiViewController: MainViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainViewControllerProvider.ContainerView>) {
        }
    }
}
