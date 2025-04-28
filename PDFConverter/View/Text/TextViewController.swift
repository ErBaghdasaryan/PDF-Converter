//
//  TextViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 28.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import StoreKit

class TextViewController: BaseViewController {

    var viewModel: ViewModel?
    private let nextButton = UIButton(type: .system)
    private let textView = CustomTextView(placeholder: "Enter text")

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        self.title = "Enter your text"

        self.nextButton.setTitle("Add", for: .normal)
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

        self.view.addSubview(textView)
        self.view.addSubview(nextButton)
        setupConstraints()
        setupNavigationItems()
        self.setupViewTapHandling()
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

        textView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(114)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview().inset(110)
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
extension TextViewController {
    
    private func makeButtonsAction() {
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }

    @objc func nextTapped() {
        guard let navigationController = self.navigationController else { return }
        guard let pdfUrl = self.viewModel?.pdfURL else { return }
        guard let text = self.textView.text else {
            self.showBadAlert(message: "Write the text first please, and then just go to the next page.")
            return
        }

        let textImage = UIImage.imageFrom(
            text: text,
            font: UIFont(name: "SFProText-Regular", size: 12)!,
            textColor: .black
        )

        SignatureRouter.showPDFSignaturePlacementViewControllerViewController(
            in: navigationController,
            navigationModel: .init(
                pdfURL: pdfUrl,
                signature: textImage,
                isText: true
            )
        )
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

        TextRouter.popViewController(in: navigationController)
    }
}

extension TextViewController: IViewModelableController {
    typealias ViewModel = ITextViewModel
}

//MARK: Preview
import SwiftUI

struct TextViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let textViewController = TextViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<TextViewControllerProvider.ContainerView>) -> TextViewController {
            return textViewController
        }

        func updateUIViewController(_ uiViewController: TextViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<TextViewControllerProvider.ContainerView>) {
        }
    }
}
