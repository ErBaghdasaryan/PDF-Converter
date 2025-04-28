//
//  SignatureViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 24.04.25.
//
import Foundation
import PDFConverterModel

public protocol ISignatureViewModel {
    var pdfURL: URL { get }
}

public class SignatureViewModel: ISignatureViewModel {

    private let signatureService: ISignatureService

    public var pdfURL: URL

    public init(signatureService: ISignatureService,
                navigationModel: PDFUrlNavigationModel) {
        self.signatureService = signatureService
        self.pdfURL = navigationModel.pdfURL
    }
}
