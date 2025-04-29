//
//  SavedFilesModel.swift
//  PDFConverterModel
//
//  Created by Er Baghdasaryan on 22.04.25.
//

import UIKit

public struct SavedFilesModel {
    public let id: Int?
    public let fileURL: URL
    public let type: PDFType
    public let password: String?

    public init(id: Int? = nil, pdfURL: URL, type: PDFType, password: String? = nil) {
        self.id = id
        self.fileURL = pdfURL
        self.type = type
        self.password = password
    }
}

public enum PDFType: String {
    case wordToPDF
    case imageToPDF
    case exelToPDF
    case pdf
    case pointToPdf
    case split
    case pdfToDoc
    case textToImage
    case pngToPdf
    case signature
    case jpegToPDF
}
