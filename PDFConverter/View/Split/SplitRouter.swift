//
//  SplitRouter.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 28.04.25.
//

import Foundation
import UIKit
import PDFConverterViewModel
import PDFConverterModel

final class SplitRouter: BaseRouter {
    static func showSplitActionViewControllerViewController(in navigationController: UINavigationController, navigationModel: SplitActionNavigationModel) {
        let viewController = ViewControllerFactory.makeSplitActionViewController(navigationModel: navigationModel)
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
