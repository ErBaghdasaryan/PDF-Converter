//
//  SplitViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 28.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import StoreKit

class SplitViewController: BaseViewController {

    var viewModel: ViewModel?
    private let nextButton = UIButton(type: .system)
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        self.nextButton.setTitle("Split", for: .normal)
        self.nextButton.setTitleColor(.white, for: .normal)
        self.nextButton.layer.cornerRadius = 12
        self.nextButton.layer.masksToBounds = true
        self.nextButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)

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

        let mylayout = UICollectionViewFlowLayout()
        mylayout.itemSize = CGSize(width: self.view.frame.width, height: 52)
        mylayout.scrollDirection = .vertical
        mylayout.minimumLineSpacing = 0
        mylayout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: mylayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SplitCell.self)

        self.view.addSubview(collectionView)
        self.view.addSubview(nextButton)
        setupConstraints()
        setupNavigationItems()
        self.setupViewTapHandling()
    }

    override func setupViewModel() {
        super.setupViewModel()
        self.viewModel?.loadData()
        self.collectionView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let gradientLayer = nextButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = nextButton.bounds
        }
    }

    func setupConstraints() {

        collectionView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(124)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview().inset(480)
        }

        nextButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(51)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(44)
        }
    }

}

//MARK: Make buttons actions
extension SplitViewController {
    
    private func makeButtonsAction() {
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }

    @objc func nextTapped() {
        guard let navigationController = self.navigationController else { return }
        
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

        SplitRouter.popViewController(in: navigationController)
    }

    private func configureCorners(for cell: UICollectionViewCell, indexPath: IndexPath) {
        let row = indexPath.row
        let itemsCount = self.viewModel?.splitItems.count ?? 0

        cell.contentView.layer.cornerRadius = 0
        cell.contentView.layer.maskedCorners = []

        let bottomView = UIView()

        bottomView.backgroundColor = UIColor(hex: "#D4DAE1")
        cell.contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(1)
        }

        if row == 0 {
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if row == itemsCount - 1 {
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            bottomView.removeFromSuperview()
        }
    }

    private func tappedCell(from index: Int) {
        switch index {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
}

extension SplitViewController: IViewModelableController {
    typealias ViewModel = ISplitViewModel
}

extension SplitViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.splitItems.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let splitCell: SplitCell = collectionView.dequeueReusableCell(for: indexPath)

        if let item = self.viewModel?.splitItems[indexPath.row] {
            splitCell.configure(with: item)
        }

        configureCorners(for: splitCell, indexPath: indexPath)

        return splitCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 52)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tappedCell(from: indexPath.row)
    }
}

//MARK: Preview
import SwiftUI

struct SplitViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let splitViewController = SplitViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<SplitViewControllerProvider.ContainerView>) -> SplitViewController {
            return splitViewController
        }

        func updateUIViewController(_ uiViewController: SplitViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SplitViewControllerProvider.ContainerView>) {
        }
    }
}
