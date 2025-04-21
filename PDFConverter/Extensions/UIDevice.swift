//
//  UIDevice.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import UIKit

enum DeviceType {
    case iPhone
    case iPad
}

extension UIDevice {
    static var currentDeviceType: DeviceType {
        return UIDevice.current.userInterfaceIdiom == .pad ? .iPad : .iPhone
    }
}
