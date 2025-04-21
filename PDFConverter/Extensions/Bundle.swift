//
//  Bundle.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import Foundation

public extension Bundle {
    var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
