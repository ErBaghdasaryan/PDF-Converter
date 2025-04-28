//
//  OnboardingViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import StoreKit

class OnboardingViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    private let bottomView = UIView()
    private let header = UILabel(text: "Unknown",
                                 textColor: UIColor(hex: "#22242C")!,
                                 font: UIFont(name: "SFProText-Bold", size: 32))
    private let subheader = UILabel(text: "Unknown",
                                    textColor: UIColor(hex: "#22242C")!,
                                    font: UIFont(name: "SFProText-Regular", size: 16))

    var collectionView: UICollectionView!
    private let nextButton = UIButton(type: .system)
    private var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.nextButton.setTitle("Start", for: .normal)
        self.nextButton.setTitleColor(.white, for: .normal)
        self.nextButton.layer.cornerRadius = 12
        self.nextButton.layer.masksToBounds = true
        self.nextButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)

        self.bottomView.layer.masksToBounds = true
        self.bottomView.layer.cornerRadius = 16

        let bottomViewGradient = CAGradientLayer()
        bottomViewGradient.colors = [
            UIColor(white: 0.976, alpha: 0.6).cgColor,
            UIColor(white: 0.976, alpha: 0.8).cgColor,
            UIColor(white: 0.976, alpha: 0.8).cgColor
        ]
        bottomViewGradient.locations = [0.0, 0.5, 1.0]
        bottomViewGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        bottomViewGradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        bottomView.layer.insertSublayer(bottomViewGradient, at: 0)
        bottomView.tag = 999

        header.numberOfLines = 0
        header.lineBreakMode = .byWordWrapping

        subheader.numberOfLines = 0
        subheader.lineBreakMode = .byWordWrapping

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
        mylayout.itemSize = sizeForItem()
        mylayout.scrollDirection = .horizontal
        mylayout.minimumLineSpacing = 0
        mylayout.minimumInteritemSpacing = 0


        collectionView = UICollectionView(frame: .zero, collectionViewLayout: mylayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(OnboardingCell.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.contentInsetAdjustmentBehavior = .never

        self.view.addSubview(collectionView)
        self.view.addSubview(bottomView)
        self.view.addSubview(header)
        self.view.addSubview(subheader)
        self.view.addSubview(nextButton)
        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()
        viewModel?.loadData()
        collectionView.reloadData()
        self.header.text = viewModel?.onboardingItems[0].header
        self.subheader.text = viewModel?.onboardingItems[0].subheader
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let gradientView = self.view.viewWithTag(999),
           let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientView.bounds
        }

        if let gradientLayer = nextButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = nextButton.bounds
        }
    }

    func sizeForItem() -> CGSize {
        let deviceType = UIDevice.currentDeviceType

        switch deviceType {
        case .iPhone:
            let width = self.view.frame.size.width
            let heightt = self.view.frame.size.height
            return CGSize(width: width, height: heightt)
        case .iPad:
            let scaleFactor: CGFloat = 1.5
            let width = 550 * scaleFactor
            let height = 1100 * scaleFactor
            return CGSize(width: width, height: height)
        }
    }

    func setupConstraints() {

        collectionView.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }

        bottomView.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(254)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(bottomView.snp.top).offset(16)
            view.leading.equalToSuperview().offset(30)
            view.trailing.equalToSuperview().inset(30)
            view.height.equalTo(70)
        }

        subheader.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(18)
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
extension OnboardingViewController {
    
    private func makeButtonsAction() {
        nextButton.addTarget(self, action: #selector(nextButtonTaped), for: .touchUpInside)
    }

    private func rate() {
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
                if let appStoreURL = URL(string: "https://apps.apple.com/us/app/pdf-converter-app/id6745167202") {
                    UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                }
            })
            present(alertController, animated: true, completion: nil)
        }
    }

    func performActionForPage(index: Int) {
        switch index {
        case 0:
            self.header.text = viewModel?.onboardingItems[index].header
            self.subheader.text = viewModel?.onboardingItems[index].subheader

            self.nextButton.setTitle("Start", for: .normal)
        case 1:
            self.header.text = viewModel?.onboardingItems[index].header
            self.subheader.text = viewModel?.onboardingItems[index].subheader

            self.nextButton.setTitle("Next", for: .normal)

            bottomView.snp.remakeConstraints { view in
                view.bottom.equalToSuperview()
                view.leading.equalToSuperview()
                view.trailing.equalToSuperview()
                view.height.equalTo(210)
            }

            header.snp.remakeConstraints { view in
                view.top.equalTo(bottomView.snp.top).offset(16)
                view.leading.equalToSuperview().offset(16)
                view.trailing.equalToSuperview().inset(16)
                view.height.equalTo(70)
            }

            subheader.snp.remakeConstraints { view in
                view.top.equalTo(header.snp.bottom).offset(8)
                view.leading.equalToSuperview().offset(10)
                view.trailing.equalToSuperview().inset(10)
                view.height.equalTo(18)
            }

            self.header.numberOfLines = 2
            self.header.lineBreakMode = .byWordWrapping

        case 2:
            rate()
            self.header.text = viewModel?.onboardingItems[index].header
            self.subheader.text = viewModel?.onboardingItems[index].subheader
            self.nextButton.setTitle("Next", for: .normal)

            bottomView.snp.remakeConstraints { view in
                view.bottom.equalToSuperview()
                view.leading.equalToSuperview()
                view.trailing.equalToSuperview()
                view.height.equalTo(238)
            }

            header.snp.remakeConstraints { view in
                view.top.equalTo(bottomView.snp.top).offset(16)
                view.leading.equalToSuperview().offset(16)
                view.trailing.equalToSuperview().inset(16)
                view.height.equalTo(34)
            }

            subheader.snp.remakeConstraints { view in
                view.top.equalTo(header.snp.bottom).offset(8)
                view.leading.equalToSuperview().offset(16)
                view.trailing.equalToSuperview().inset(16)
                view.height.equalTo(60)
            }

            self.subheader.numberOfLines = 0
            self.subheader.lineBreakMode = .byWordWrapping
        default:
            break
        }
    }

    @objc func nextButtonTaped() {
        guard let navigationController = self.navigationController else { return }

        let numberOfItems = self.collectionView.numberOfItems(inSection: 0)
        let nextRow = self.currentIndex + 1

        if nextRow < numberOfItems {
            let nextIndexPath = IndexPath(item: nextRow, section: 0)
            self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            self.currentIndex = nextRow
            self.performActionForPage(index: currentIndex)
        } else {
            OnboardingRouter.showNotificationViewController(in: navigationController)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleItems = collectionView.indexPathsForVisibleItems.sorted()
        if let visibleItem = visibleItems.first {
            currentIndex = visibleItem.item
            self.performActionForPage(index: currentIndex)
        }
    }
}

extension OnboardingViewController: IViewModelableController {
    typealias ViewModel = IOnboardingViewModel
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel?.onboardingItems.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setup(image: viewModel?.onboardingItems[indexPath.row].image ?? "")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

//MARK: Preview
import SwiftUI

struct OnboardingViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let onboardingViewController = OnboardingViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<OnboardingViewControllerProvider.ContainerView>) -> OnboardingViewController {
            return onboardingViewController
        }

        func updateUIViewController(_ uiViewController: OnboardingViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<OnboardingViewControllerProvider.ContainerView>) {
        }
    }
}
