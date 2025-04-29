//
//  NotificationViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import StoreKit
import OneSignalFramework

class NotificationViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    private let bottomView = UIView()
    private let header = UILabel(text: "Enable notification",
                                 textColor: UIColor(hex: "#22242C")!,
                                 font: UIFont(name: "SFProText-Bold", size: 32))
    private let subheader = UILabel(text: "Analyze the strategies of other accounts and stand out from them",
                                    textColor: UIColor(hex: "#22242C")!,
                                    font: UIFont(name: "SFProText-Regular", size: 16))

    private let backgroundImage = UIImageView(image: UIImage(named: "onboarding4"))
    private let nextButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.nextButton.setTitle("Continue", for: .normal)
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

        self.backgroundImage.frame = self.view.bounds

        self.view.addSubview(backgroundImage)
        self.view.addSubview(bottomView)
        self.view.addSubview(header)
        self.view.addSubview(subheader)
        self.view.addSubview(nextButton)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
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

    func setupConstraints() {

        backgroundImage.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }

        bottomView.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(220)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(bottomView.snp.top).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(34)
        }

        subheader.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(31)
            view.trailing.equalToSuperview().inset(31)
            view.height.equalTo(40)
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
extension NotificationViewController {
    
    private func makeButtonsAction() {
        nextButton.addTarget(self, action: #selector(nextButtonTaped), for: .touchUpInside)
    }

    @objc func maybeLater() {
        guard let navigationController = self.navigationController else { return }
        NotificationRouter.showPaymentViewController(in: navigationController)
    }

    @objc func nextButtonTaped() {
        guard let navigationController = self.navigationController else { return }

        OneSignal.Notifications.requestPermission({ accepted in
            DispatchQueue.main.async {
                if accepted {
                    self.showNTFSuccessAlert(message: "You have successfully enabled your notifications.")
                } else {
                    self.showNTFBadAlert(message: "You haven't enabled your notifications!")
                }
            }
        }, fallbackToSettings: true)
    }

    func showNTFSuccessAlert(message: String) {
        guard let navigationController = self.navigationController else { return }
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            NotificationRouter.showPaymentViewController(in: navigationController)
            self.viewModel?.isEnabled = true
        }))
        present(alert, animated: true, completion: nil)
    }

    func showNTFBadAlert(message: String) {
        guard let navigationController = self.navigationController else { return }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            NotificationRouter.showPaymentViewController(in: navigationController)
            self.viewModel?.isEnabled = true
        }))
        present(alert, animated: true, completion: nil)
    }

    private func setupNavigationItems() {

        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "ntfBack"), for: .normal)
        backbutton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        backbutton.addTarget(self, action: #selector(maybeLater), for: .touchUpInside)

        let leftButton = UIBarButtonItem(customView: backbutton)

        navigationItem.leftBarButtonItem = leftButton
    }
}

extension NotificationViewController: IViewModelableController {
    typealias ViewModel = INotificationViewModel
}

//MARK: Preview
import SwiftUI

struct NotificationViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let notificationViewController = NotificationViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<NotificationViewControllerProvider.ContainerView>) -> NotificationViewController {
            return notificationViewController
        }

        func updateUIViewController(_ uiViewController: NotificationViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<NotificationViewControllerProvider.ContainerView>) {
        }
    }
}
