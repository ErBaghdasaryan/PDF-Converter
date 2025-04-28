//
//  SignatureRouter.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import Foundation
import UIKit
import PDFConverterViewModel
import PDFConverterModel

final class SignatureRouter: BaseRouter {
    static func showPDFSignaturePlacementViewControllerViewController(in navigationController: UINavigationController, navigationModel: PDFSignaturePlacementServiceNavModel) {
        let viewController = ViewControllerFactory.makePDFSignaturePlacementViewControllerViewController(navigationModel: navigationModel)
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
