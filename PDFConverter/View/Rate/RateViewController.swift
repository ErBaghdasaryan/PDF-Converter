//
//  RateViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 16.05.25.
//

import UIKit
import SnapKit
import PDFConverterViewModel
import StoreKit

class RateViewController: BaseViewController {

    var viewModel: ViewModel?

    private let rateImage = UIImageView(image: UIImage(named: "rateImage"))
    private let header = UILabel(text: "Do you like our app?",
                                 textColor: UIColor(hex: "#22242C")!,
                                 font: UIFont(name: "SFProText-Bold", size: 32))

    private let subheader = UILabel(text: "Please rate our app so we can improve it for you and make it even cooler !",
                                    textColor: UIColor(hex: "#22242C")!.withAlphaComponent(0.7),
                                    font: UIFont(name: "SFProText-Regular", size: 16))

    private let yes = UIButton(type: .system)
    private let no = UIButton(type: .system)

    var didAppearCallback: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    deinit {
        didAppearCallback?()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        self.yes.setTitle("Yes", for: .normal)
        self.yes.setTitleColor(.white, for: .normal)
        self.yes.layer.cornerRadius = 12
        self.yes.layer.masksToBounds = true
        self.yes.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 15)
        self.yes.backgroundColor = UIColor(hex: "#358E61")

        self.no.setTitle("No", for: .normal)
        self.no.setTitleColor(UIColor(hex: "#22242C")!, for: .normal)
        self.no.layer.cornerRadius = 12
        self.no.layer.masksToBounds = true
        self.no.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 15)
        self.no.layer.borderColor = UIColor(hex: "#22242C")?.cgColor
        self.no.layer.borderWidth = 1

        self.subheader.numberOfLines = 0
        self.subheader.lineBreakMode = .byWordWrapping

        self.view.addSubview(rateImage)
        self.view.addSubview(header)
        self.view.addSubview(subheader)
        self.view.addSubview(yes)
        self.view.addSubview(no)
        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {

        rateImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(177)
            view.leading.equalToSuperview().offset(84)
            view.trailing.equalToSuperview().inset(84)
            view.bottom.equalToSuperview().inset(440)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(rateImage.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(34)
        }

        subheader.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(53)
            view.trailing.equalToSuperview().inset(53)
            view.height.equalTo(40)
        }

        yes.snp.makeConstraints { view in
            view.top.equalTo(subheader.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(44)
        }

        no.snp.makeConstraints { view in
            view.top.equalTo(yes.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(44)
        }
    }

}

//MARK: Make buttons actions
extension RateViewController {
    
    private func makeButtonsAction() {
        yes.addTarget(self, action: #selector(yesTapped), for: .touchUpInside)
        no.addTarget(self, action: #selector(noTapped), for: .touchUpInside)
    }

    @objc func yesTapped() {
        ReviewManager.shared.requestReviewOrRedirect()
    }

    @objc func noTapped() {
        self.dismiss(animated: true)
    }
}

extension RateViewController: IViewModelableController {
    typealias ViewModel = IRateViewModel
}


//MARK: Preview
import SwiftUI

struct RateViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let rateViewController = RateViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<RateViewControllerProvider.ContainerView>) -> RateViewController {
            return rateViewController
        }

        func updateUIViewController(_ uiViewController: RateViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<RateViewControllerProvider.ContainerView>) {
        }
    }
}
