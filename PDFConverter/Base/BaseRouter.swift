//
//  BaseRouter.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import UIKit
import Combine
import PDFConverterViewModel

class BaseRouter {

    class func popViewController(in navigationController: UINavigationController, completion: (() -> Void)? = nil) {
        completion?()
        navigationController.popViewController(animated: true)
    }
}
