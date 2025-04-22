//
//  MainItem.swift
//  PDFConverterModel
//
//  Created by Er Baghdasaryan on 22.04.25.
//

import UIKit

public struct MainItem {
    public let icon: UIImage?
    public let title: String

    public init(icon: UIImage?, title: String) {
        self.icon = icon
        self.title = title
    }
}

public enum MainSection {
    case popular
    case other
}
