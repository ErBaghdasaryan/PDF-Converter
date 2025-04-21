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
}
