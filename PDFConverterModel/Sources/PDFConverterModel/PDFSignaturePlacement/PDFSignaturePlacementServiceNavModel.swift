//
//  PDFSignaturePlacementServiceNavModel.swift
//  PDFConverterModel
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import UIKit

public final class PDFSignaturePlacementServiceNavModel {
    public var pdfURL: URL
    public var signature: UIImage
    public var isText: Bool

    public init(pdfURL: URL, signature: UIImage, isText: Bool = false) {
        self.pdfURL = pdfURL
        self.signature = signature
        self.isText = isText
    }
}
