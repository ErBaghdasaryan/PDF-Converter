//
//  SignatureViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import StoreKit

class SignatureViewController: BaseViewController {

    var viewModel: ViewModel?
    private let bottomView = UIView()
    private let line = UIView()
    private let signHere = UILabel(text: "Sign here",
                                 textColor: UIColor(hex: "#5F6E85")!,
                                 font: UIFont(name: "SFProText-Regular", size: 16))
    private let signature = SignatureView()
    private let deleteButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        self.title = "Create a signature"

        self.bottomView.backgroundColor = UIColor(hex: "#F9F9F9")
        self.bottomView.layer.masksToBounds = true
        self.bottomView.layer.cornerRadius = 12

        self.nextButton.setTitle("Next", for: .normal)
        self.nextButton.setTitleColor(.white, for: .normal)
        self.nextButton.layer.cornerRadius = 12
        self.nextButton.layer.masksToBounds = true
        self.nextButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)
    
        self.line.backgroundColor = UIColor(hex: "#D4DAE1")

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

        deleteButton.setImage(UIImage(named: "deleteSign"), for: .normal)

        self.view.addSubview(bottomView)
        self.view.addSubview(line)
        self.view.addSubview(signHere)
        self.view.addSubview(signature)
        self.view.addSubview(deleteButton)
        self.view.addSubview(nextButton)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let gradientLayer = nextButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = nextButton.bounds
        }
    }

    func setupConstraints() {

        bottomView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(124)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview().inset(127)
        }

        line.snp.makeConstraints { view in
            view.top.equalTo(bottomView.snp.top).offset(273)
            view.leading.equalToSuperview().offset(52)
            view.trailing.equalToSuperview().inset(52)
            view.height.equalTo(1)
        }

        signHere.snp.makeConstraints { view in
            view.top.equalTo(line.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(52)
            view.trailing.equalToSuperview().inset(52)
            view.height.equalTo(18)
        }

        signature.snp.makeConstraints { view in
            view.top.equalTo(bottomView.snp.top)
            view.leading.equalToSuperview().offset(52)
            view.trailing.equalToSuperview().inset(52)
            view.bottom.equalTo(line.snp.top)
        }

        deleteButton.snp.makeConstraints { view in
            view.bottom.equalTo(bottomView.snp.bottom).inset(16)
            view.trailing.equalTo(bottomView.snp.trailing).inset(16)
            view.height.equalTo(56)
            view.width.equalTo(56)
        }

        nextButton.snp.makeConstraints { view in
            view.bottom.equalTo(bottomView.snp.bottom).offset(51)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(44)
        }
    }

}

//MARK: Make buttons actions
extension SignatureViewController {
    
    private func makeButtonsAction() {
        deleteButton.addTarget(self, action: #selector(deleteSignature), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }

    @objc func nextTapped() {
        guard let navigationController = self.navigationController else { return }
        guard let pdfUrl = self.viewModel?.pdfURL else { return }
        let signature = self.signature.getSignatureImage()

        SignatureRouter.showPDFSignaturePlacementViewControllerViewController(in: navigationController, navigationModel: .init(pdfURL: pdfUrl, signature: signature))
    }

    @objc func deleteSignature() {
        self.signature.clear()
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

        SignatureRouter.popViewController(in: navigationController)
    }
}

extension SignatureViewController: IViewModelableController {
    typealias ViewModel = ISignatureViewModel
}

//MARK: Preview
import SwiftUI

struct SignatureViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let signatureViewController = SignatureViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<SignatureViewControllerProvider.ContainerView>) -> SignatureViewController {
            return signatureViewController
        }

        func updateUIViewController(_ uiViewController: SignatureViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SignatureViewControllerProvider.ContainerView>) {
        }
    }
}
