//
//  SplitActionNavigationModel.swift
//  PDFConverterModel
//
//  Created by Er Baghdasaryan on 29.04.25.
//

import Foundation

public final class SplitActionNavigationModel {
    public var pdfURL: URL
    public var action: SplitAction

    public init(pdfURL: URL, action: SplitAction) {
        self.pdfURL = pdfURL
        self.action = action
    }
}

public enum SplitAction {
    case divideByRange
    case fixedRange
    case deletePages
}
