//
//  HistoryViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit

class HistoryViewController: BaseViewController {

    var viewModel: ViewModel?
    private let header = UILabel(text: "Last",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Bold", size: 18))
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel?.loadFiles()
        self.collectionView.reloadData()
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

    private func setPageToMain() {
        NotificationCenter.default.post(name: Notification.Name("setPageToMain"), object: nil, userInfo: nil)
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
                cell.configure(firstImage: model.genre,
                               secondImage: model.subGenre,
                               title: "\(model.genre) + \(model.subGenre)",
                               data: [model.genre, model.subGenre, model.duration])
            }

            cell.deleteTapped.sink { [weak self] _ in
//                if let model = self?.viewModel?.savedFiles[indexPath.row] {
//                    self?.deleteMusic(for: model.id!)
//                }
            }.store(in: &cell.cancellables)

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.viewModel?.savedFiles[indexPath.row] {
//            self.showEditMusicViewController(with: model)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.viewModel?.savedFiles.isEmpty ?? true {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: 343, height: 65)
        }
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
