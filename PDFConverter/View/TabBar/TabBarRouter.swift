//
//  TabBarRouter.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 16.05.25.
//

import Foundation
import UIKit
import PDFConverterViewModel

final class TabBarRouter: BaseRouter {
    static func showRateViewController(in navigationController: UIViewController, onAppear: (() -> Void)? = nil) {
        let viewController = ViewControllerFactory.makeRateViewController()
        viewController.didAppearCallback = onAppear
        viewController.modalPresentationStyle = .formSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(viewController, animated: true)
    }
}
