//
//  BaseViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import UIKit
import Combine
import PDFConverterViewModel

public protocol IViewModelableController {
    associatedtype ViewModel

    var viewModel: ViewModel? { get }
}

class BaseViewController: UIViewController {
    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(resetProgress), name: Notification.Name("ResetCompleted"), object: nil)
    }

    func setupUI() {

    }

    func setupViewModel() {
        
    }

    @objc func resetProgress() {
        
    }

    func showSuccessAlert(message: String, onOk: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                onOk?()
        }

        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func showBadAlert(message: String, onOk: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                onOk?()
        }

        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func addSwipeToBack() {
        let swipeToRight = UISwipeGestureRecognizer(target: self, action: #selector(popAfterSwipeLeft))
        swipeToRight.direction = .right
        self.view.addGestureRecognizer(swipeToRight)
    }

    @objc private func popAfterSwipeLeft() {
        guard let navigationController = self.navigationController else { return }
        BaseRouter.popViewController(in: navigationController)
    }

    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }

    func setupViewTapHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Deinit
    deinit {
        #if DEBUG
        print("deinit \(String(describing: self))")
        NotificationCenter.default.removeObserver(self)
        #endif
    }
}
