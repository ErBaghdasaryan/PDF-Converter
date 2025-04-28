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
    static func showPDFSignaturePlacementViewControllerViewController(in navigationController: UINavigationController, navigationModel: PDFSignaturePlacementServiceNavModel) {
        let viewController = ViewControllerFactory.makePDFSignaturePlacementViewControllerViewController(navigationModel: navigationModel)
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
