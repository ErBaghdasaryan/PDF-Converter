//
//  OnboardingRouter.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import Foundation
import UIKit
import PDFConverterViewModel

final class OnboardingRouter: BaseRouter {
    static func showNotificationViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makeNotificationViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(viewController, animated: true)
    }
}
