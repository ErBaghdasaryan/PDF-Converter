//
//  TextViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 28.04.25.
//

import Foundation
import PDFConverterModel

public protocol ITextViewModel {
    var pdfURL: URL { get }
}

public class TextViewModel: ITextViewModel {

    private let textService: ITextService

    public var pdfURL: URL

    public init(textService: ITextService,
                navigationModel: PDFUrlNavigationModel) {
        self.textService = textService
        self.pdfURL = navigationModel.pdfURL
    }
}
