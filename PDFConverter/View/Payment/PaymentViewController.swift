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
    private let bottomView = UIImageView(image: UIImage(named: "paymentBlur"))
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

        self.view.backgroundColor = .clear

        self.continueButton.setTitle("Continue", for: .normal)
        self.continueButton.setTitleColor(.white, for: .normal)
        self.continueButton.layer.cornerRadius = 12
        self.continueButton.layer.masksToBounds = true
        self.continueButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)

        self.bottomView.layer.masksToBounds = true
        self.bottomView.layer.cornerRadius = 16

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

        self.paymenButtons = UIStackView(arrangedSubviews: [yearlyButton, weeklyButton],
                                        axis: .vertical,
                                        spacing: 8)
        self.paymenButtons.distribution = .fillEqually

        self.subheader.numberOfLines = 0
        self.subheader.lineBreakMode = .byWordWrapping

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
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

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
            view.height.equalTo(436)
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
            view.height.equalTo(130)
        }

        continueButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(42)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(44)
        }

        maybeLater.snp.makeConstraints { view in
            view.bottom.equalTo(continueButton.snp.top).inset(-10)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(32)
        }
    }

}

//MARK: Make buttons actions
extension PaymentViewController {
    
    private func makeButtonsAction() {
        continueButton.addTarget(self, action: #selector(continueButtonTaped), for: .touchUpInside)
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
    public func loadPaywalls() {
        Apphud.paywallsDidLoadCallback { paywalls, error in
            if let error = error {
                print("Ошибка загрузки paywalls: \(error.localizedDescription)")
            } else if let paywall = paywalls.first(where: { $0.identifier == self.paywallID }) {
                Apphud.paywallShown(paywall)
                self.productsAppHud = paywall.products

                self.yearlyButton.isSelectedState = true
                self.weeklyButton.isSelectedState = false
                self.currentProduct = self.productsAppHud[1]

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
