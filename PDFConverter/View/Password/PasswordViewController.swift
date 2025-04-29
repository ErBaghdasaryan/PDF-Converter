//
//  PasswordViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 29.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import StoreKit

class PasswordViewController: BaseViewController {

    var viewModel: ViewModel?
    private let header = UILabel(text: "Create a password code",
                                 textColor: UIColor.black,
                                 font: UIFont(name: "SFProText-Bold", size: 18))
    private let first = CustomTextField(passwordPlaceholder: ".")
    private let second = CustomTextField(passwordPlaceholder: ".")
    private let third = CustomTextField(passwordPlaceholder: ".")
    private let fourth = CustomTextField(passwordPlaceholder: ".")
    private var fieldsStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        first.becomeFirstResponder()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        self.fieldsStack = UIStackView(arrangedSubviews: [first, second, third, fourth],
                                       axis: .horizontal,
                                       spacing: 16)
        self.fieldsStack.distribution = .fillEqually

        self.view.addSubview(header)
        self.view.addSubview(fieldsStack)
        setupConstraints()
        self.setupViewTapHandling()
        setupTextFieldDelegates()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {

        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(28)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(20)
        }

        fieldsStack.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(74)
        }
    }

}

//MARK: Make buttons actions
extension PasswordViewController {
    
    private func makeButtonsAction() {

    }

    private func saveAndUpdatePassword(password: String) {
        guard let model = self.viewModel?.model else { return }

        self.viewModel?.updateSavedFile(.init(id: model.id,
                                              pdfURL: model.fileURL,
                                              type: model.type,
                                              password: password))

        self.showSuccessAlert(message: "Your password has been added and saved. Check it in the 'History' section.") {
            if let sceneDelegate = UIApplication.shared.connectedScenes
                .first?.delegate as? SceneDelegate {
                sceneDelegate.startTabBarFlow()
            }
        }
    }

}

extension PasswordViewController: IViewModelableController {
    typealias ViewModel = IPasswordViewModel
}

//MARK: UIGesturePasswordViewController& cell's touches
extension PasswordViewController: UITextFieldDelegate, UITextViewDelegate {

    private func setupTextFieldDelegates() {
        self.first.delegate = self
        self.second.delegate = self
        self.third.delegate = self
        self.fourth.delegate = self

        self.first.keyboardType = .numberPad
        self.second.keyboardType = .numberPad
        self.third.keyboardType = .numberPad
        self.fourth.keyboardType = .numberPad
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }

        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if newText.count > 1 {
            return false
        }

        textField.text = string

        if string.count == 1 {
            switch textField {
            case self.first:
                self.second.becomeFirstResponder()
            case self.second:
                self.third.becomeFirstResponder()
            case self.third:
                self.fourth.becomeFirstResponder()
            case self.fourth:
                self.fourth.resignFirstResponder()
                let code = [first.text, second.text, third.text, fourth.text].compactMap { $0 }.joined()
                saveAndUpdatePassword(password: code)
            default:
                break
            }
        }

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.first:
            self.second.becomeFirstResponder()
        case self.second:
            self.third.becomeFirstResponder()
        case self.third:
            self.fourth.becomeFirstResponder()
        case self.fourth:
            self.fourth.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

//MARK: Preview
import SwiftUI

struct PasswordViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let passwordViewController = PasswordViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<PasswordViewControllerProvider.ContainerView>) -> PasswordViewController {
            return passwordViewController
        }

        func updateUIViewController(_ uiViewController: PasswordViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PasswordViewControllerProvider.ContainerView>) {
        }
    }
}
