//
//  SplitViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 28.04.25.
//

import Foundation
import PDFConverterModel

public protocol ISplitViewModel {
    var pdfURL: URL { get }
    func loadData()
    var splitItems: [String] { get set }
}

public class SplitViewModel: ISplitViewModel {

    private let splitService: ISplitService

    public var pdfURL: URL

    public var splitItems: [String] = []

    public init(splitService: ISplitService,
                navigationModel: PDFUrlNavigationModel) {
        self.splitService = splitService
        self.pdfURL = navigationModel.pdfURL
    }

    public func loadData() {
        self.splitItems = self.splitService.getSplitItems()
    }
}
