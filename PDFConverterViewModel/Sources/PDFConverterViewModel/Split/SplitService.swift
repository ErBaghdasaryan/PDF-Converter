//
//  SplitService.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 28.04.25.
//

import UIKit
import PDFConverterModel

public protocol ISplitService {
    func getSplitItems() -> [String]
}

public class SplitService: ISplitService {

    public init() { }

    public func getSplitItems() -> [String] {
        [
            "Divide by range",
            "Fixed range",
            "Delite pages"
        ]
    }
}
