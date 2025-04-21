//
//  NotificationRouter.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import Foundation
import UIKit
import PDFConverterViewModel

final class NotificationRouter: BaseRouter {
    static func showPaymentViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makePaymentViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
