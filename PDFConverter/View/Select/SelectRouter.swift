//
//  SelectRouter.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import Foundation
import UIKit
import PDFConverterViewModel
import PDFConverterModel

final class SelectRouter: BaseRouter {
    static func showSignatureViewController(in navigationController: UINavigationController, navigationModel: PDFUrlNavigationModel) {
        let viewController = ViewControllerFactory.makeSignatureViewController(navigationModel: navigationModel)
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    static func showTextViewController(in navigationController: UINavigationController, navigationModel: PDFUrlNavigationModel) {
        let viewController = ViewControllerFactory.makeTextViewController(navigationModel: navigationModel)
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
