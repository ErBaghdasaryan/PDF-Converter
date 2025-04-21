//
//  MainViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit

class MainViewController: BaseViewController {

    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white


        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {

    }

}

//MARK: Make buttons actions
extension MainViewController {
    
    private func makeButtonsAction() {

    }

    @objc func openSettings() {
        guard let navigationController = self.navigationController else { return }

        MainRouter.showSettingsViewController (in: navigationController)
    }

    private func setupNavigationItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "getPro"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 110, height: 32)
        button.addTarget(self, action: #selector(getProSubscription), for: .touchUpInside)

        let button1 = UIButton(type: .custom)
        button1.setImage(UIImage(named: "mainSetttings"), for: .normal)
        button1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button1.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        let proButton = UIBarButtonItem(customView: button)
        let leftButton = UIBarButtonItem(customView: button1)
        navigationItem.leftBarButtonItem = leftButton

        navigationItem.rightBarButtonItem = proButton

    }

    @objc func getProSubscription() {
        guard let navigationController = self.navigationController else { return }

//        if Apphud.hasActiveSubscription() {
//            SettingsRouter.showUpdatePaymentViewController(in: navigationController)
//        } else {
            MainRouter.showPaymentViewController(in: navigationController)
//        }
    }
}

extension MainViewController: IViewModelableController {
    typealias ViewModel = IMainViewModel
}

//MARK: Preview
import SwiftUI

struct MainViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let mainViewController = MainViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<MainViewControllerProvider.ContainerView>) -> MainViewController {
            return mainViewController
        }

        func updateUIViewController(_ uiViewController: MainViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainViewControllerProvider.ContainerView>) {
        }
    }
}
