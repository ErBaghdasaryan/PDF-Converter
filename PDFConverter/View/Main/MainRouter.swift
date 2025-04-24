//
//  MainRouter.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import Foundation
import UIKit
import PDFConverterViewModel

final class MainRouter: BaseRouter {
    static func showPaymentViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makePaymentViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    static func showSettingsViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makeSettingsViewController()
        viewController.modalPresentationStyle = .formSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(viewController, animated: true)
    }

    static func showSelectViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makeSelectViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
