//
//  PDFSignaturePlacementViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import UIKit
import PDFConverterModel

public protocol IPDFSignaturePlacementViewModel {
    var pdfURL: URL { get }
    var signatureImage: UIImage { get }
    var isText: Bool { get }
    func addSavedFile(_ model: SavedFilesModel)
}

public class PDFSignaturePlacementViewModel: IPDFSignaturePlacementViewModel {

    private let PDFSignaturePlacementService: IPDFSignaturePlacementService

    public var pdfURL: URL
    public var signatureImage: UIImage
    public var isText: Bool

    public init(PDFSignaturePlacementService: IPDFSignaturePlacementService,
                navigationModel: PDFSignaturePlacementServiceNavModel) {
        self.PDFSignaturePlacementService = PDFSignaturePlacementService
        self.pdfURL = navigationModel.pdfURL
        self.signatureImage = navigationModel.signature
        self.isText = navigationModel.isText
    }

    public func addSavedFile(_ model: SavedFilesModel) {
        do {
            _ = try self.PDFSignaturePlacementService.addSavedFile(model)
        } catch {
            print(error)
        }
    }
}
