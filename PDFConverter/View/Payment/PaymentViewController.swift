//
//  PaymentViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import ApphudSDK

class PaymentViewController: BaseViewController {

    var viewModel: ViewModel?

    private let background = UIImageView(image: UIImage(named: "paymentBG"))
    private let bottomView = UIView()
    private let header = UILabel(text: "Unlock",
                                 textColor: .black,
                                 font: UIFont(name: "SFProText-Bold", size: 34))
    private let header1 = UILabel(text: "Powerful Insights",
                                 textColor: .black,
                                 font: UIFont(name: "SFProText-Bold", size: 34))
    private let subheader = UILabel(text: "Discover who unfollowed you, gain insights into your story analystics, and much more",
                                    textColor: UIColor(hex: "#22242C")!.withAlphaComponent(0.7),
                                    font: UIFont(name: "SFProText-Regular", size: 16))

    private let continueButton = UIButton(type: .system)
    private let maybeLater = UILabel()
    private let terms = UIButton(type: .system)
    private let privacy = UIButton(type: .system)
    private let restore = UIButton(type: .system)
    private var buttonsStack: UIStackView!
    private let cancele = UIButton(type: .system)

    private let weeklyButton = PaymentButton(type: .weekly)
    private let yearlyButton = PaymentButton(type: .yearly)

    private var paymenButtons: UIStackView!

    private var currentProduct: ApphudProduct?
    public let paywallID = "main"
    public var productsAppHud: [ApphudProduct] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
        self.loadPaywalls()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.cancele.isHidden = false
        }
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        self.continueButton.setTitle("Continue", for: .normal)
        self.continueButton.setTitleColor(.white, for: .normal)
        self.continueButton.layer.cornerRadius = 12
        self.continueButton.layer.masksToBounds = true
        self.continueButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)

        self.bottomView.layer.masksToBounds = true
        self.bottomView.layer.cornerRadius = 16

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
                                                           privacy,
                                                           restore],
                                        axis: .horizontal,
                                        spacing: 0)
        self.buttonsStack.distribution = .fillEqually

        let image = UIImage(named: "cancelAnytime")
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: -6, width: 20, height: 20)

        let attachmentString = NSAttributedString(attachment: attachment)
        let text = NSMutableAttributedString(string: " Cancel anytime")
        text.insert(attachmentString, at: 0)

        maybeLater.attributedText = text
        maybeLater.font = UIFont(name: "SFProText-Regular", size: 12)
        maybeLater.textColor = UIColor(hex: "#22242C")!.withAlphaComponent(0.7)
        maybeLater.textAlignment = .center
        maybeLater.isUserInteractionEnabled = true

        self.cancele.setImage(UIImage(named: "ntfBack"), for: .normal)
        self.cancele.isHidden = true

        self.paymenButtons = UIStackView(arrangedSubviews: [weeklyButton, yearlyButton],
                                        axis: .horizontal,
                                        spacing: 16)
        self.paymenButtons.distribution = .fillEqually

        self.subheader.numberOfLines = 0
        self.subheader.lineBreakMode = .byWordWrapping

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
        continueButton.layer.insertSublayer(buttonGradient, at: 0)

        self.view.addSubview(background)
        self.view.addSubview(bottomView)
        self.view.addSubview(cancele)
        self.view.addSubview(header)
        self.view.addSubview(header1)
        self.view.addSubview(subheader)
        self.view.addSubview(paymenButtons)
        self.view.addSubview(continueButton)
        self.view.addSubview(maybeLater)
        self.view.addSubview(buttonsStack)
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let gradientView = self.view.viewWithTag(999),
           let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientView.bounds
        }

        if let gradientLayer = continueButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = continueButton.bounds
        }
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {

        background.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview().inset(318)
        }

        bottomView.snp.makeConstraints { view in
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(454)
        }

        cancele.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(56)
            view.leading.equalToSuperview().offset(16)
            view.width.equalTo(32)
            view.height.equalTo(32)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(bottomView.snp.top).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(34)
        }

        header1.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(34)
        }

        subheader.snp.makeConstraints { view in
            view.top.equalTo(header1.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(40)
        }

        paymenButtons.snp.makeConstraints { view in
            view.top.equalTo(subheader.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(122)
        }

        continueButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(112)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(44)
        }

        maybeLater.snp.makeConstraints { view in
            view.top.equalTo(continueButton.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(32)
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
extension PaymentViewController {
    
    private func makeButtonsAction() {
        continueButton.addTarget(self, action: #selector(continueButtonTaped), for: .touchUpInside)
        restore.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        privacy.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        terms.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        cancele.addTarget(self, action: #selector(cancelTaped), for: .touchUpInside)
        yearlyButton.addTarget(self, action: #selector(planAction(_:)), for: .touchUpInside)
        weeklyButton.addTarget(self, action: #selector(planAction(_:)), for: .touchUpInside)
    }
    
    @objc func planAction(_ sender: UIButton) {
        switch sender {
        case yearlyButton:
            self.yearlyButton.isSelectedState = true
            self.weeklyButton.isSelectedState = false
            self.currentProduct = self.productsAppHud[1]
        case weeklyButton:
            self.yearlyButton.isSelectedState = false
            self.weeklyButton.isSelectedState = true
            self.currentProduct = self.productsAppHud.first
        default:
            break
        }
    }
    
    @objc func cancelTaped() {
        if let navigationController = self.navigationController {
            let viewControllers = navigationController.viewControllers
            
            if let currentIndex = viewControllers.firstIndex(of: self), currentIndex > 0 {
                let previousViewController = viewControllers[currentIndex - 1]
                
                if previousViewController is NotificationViewController {
                    PaymentRouter.showTabBarViewController(in: navigationController)
                } else {
                    navigationController.navigationBar.isHidden = false
                    navigationController.navigationItem.hidesBackButton = false
                    navigationController.popViewController(animated: true)
                }
            }
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @objc func privacyTapped() {
        guard let navigationController = self.navigationController else { return }
        PaymentRouter.showPrivacyViewController(in: navigationController)
    }
    
    @objc func termsTapped() {
        guard let navigationController = self.navigationController else { return }
        PaymentRouter.showTermsViewController(in: navigationController)
    }
    
    @objc func continueButtonTaped() {
        if let navigationController = self.navigationController {
            guard let currentProduct = self.currentProduct else {
                self.showBadAlert(message: "Please, first, choose which plan you want to move forward on, just click")
                return
            }
            
            startPurchase(product: currentProduct) { result in
                let viewControllers = navigationController.viewControllers
                
                if let currentIndex = viewControllers.firstIndex(of: self), currentIndex > 0 {
                    let previousViewController = viewControllers[currentIndex - 1]
                    
                    if previousViewController is NotificationViewController {
                        PaymentRouter.showTabBarViewController(in: navigationController)
                    } else {
                        navigationController.navigationBar.isHidden = false
                        navigationController.navigationItem.hidesBackButton = false
                        navigationController.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @objc func restoreTapped() {
        guard let navigationController = self.navigationController else { return }
        self.restorePurchase { result in
            if result {
                self.showSuccessAlert(message: "You have successfully restored your purchases.")
            } else {
                self.showBadAlert(message: "Your purchase could not be restored. Please try again later.")
            }
        }
        
        let viewControllers = navigationController.viewControllers
        
        if let currentIndex = viewControllers.firstIndex(of: self), currentIndex > 0 {
            let previousViewController = viewControllers[currentIndex - 1]
            
            if previousViewController is NotificationViewController {
                PaymentRouter.showTabBarViewController(in: navigationController)
            } else {
                navigationController.navigationBar.isHidden = false
                navigationController.navigationItem.hidesBackButton = false
                navigationController.popViewController(animated: true)
            }
        }
    }
    
    @MainActor
    public func startPurchase(product: ApphudProduct, escaping: @escaping(Bool) -> Void) {
        let selectedProduct = product
        Apphud.purchase(selectedProduct) { result in
            if let error = result.error {
                print(error.localizedDescription)
                escaping(false)
            }
            
            if let subscription = result.subscription, subscription.isActive() {
                escaping(true)
            } else if let purchase = result.nonRenewingPurchase, purchase.isActive() {
                escaping(true)
            } else {
                if Apphud.hasActiveSubscription() {
                    escaping(true)
                }
            }
        }
    }
    
    @MainActor
    public func restorePurchase(escaping: @escaping(Bool) -> Void) {
        Apphud.restorePurchases { subscriptions, _, error in
            if let error = error {
                print(error.localizedDescription)
                escaping(false)
            }
            if subscriptions?.first?.isActive() ?? false {
                escaping(true)
            }
            if Apphud.hasActiveSubscription() {
                escaping(true)
            }
        }
    }
    
    @MainActor
    public func loadPaywalls() {
        Apphud.paywallsDidLoadCallback { paywalls, error in
            if let error = error {
                print("Ошибка загрузки paywalls: \(error.localizedDescription)")
            } else if let paywall = paywalls.first(where: { $0.identifier == self.paywallID }) {
                Apphud.paywallShown(paywall)
                self.productsAppHud = paywall.products
                print("Продукты успешно загружены: \(self.productsAppHud)")
            } else {
                print("Paywall с идентификатором \(self.paywallID) не найден.")
            }
        }
    }
}

extension PaymentViewController: IViewModelableController {
    typealias ViewModel = IPaymentViewModel
}


//MARK: Preview
import SwiftUI

struct PaymentViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let paymentViewController = PaymentViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<PaymentViewControllerProvider.ContainerView>) -> PaymentViewController {
            return paymentViewController
        }

        func updateUIViewController(_ uiViewController: PaymentViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PaymentViewControllerProvider.ContainerView>) {
        }
    }
}
