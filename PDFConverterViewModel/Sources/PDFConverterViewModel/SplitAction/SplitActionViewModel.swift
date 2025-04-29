//
//  SplitActionViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 29.04.25.
//

import Foundation
import PDFConverterModel

public protocol ISplitActionViewModel {
    var pdfURL: URL { get }
    var action: SplitAction { get }
    func addSavedFile(_ model: SavedFilesModel)
}

public class SplitActionViewModel: ISplitActionViewModel {

    private let splitActionService: ISplitActionService

    public var pdfURL: URL
    public var action: SplitAction

    public var splitItems: [String] = []

    public init(splitActionService: ISplitActionService,
                navigationModel: SplitActionNavigationModel) {
        self.splitActionService = splitActionService
        self.pdfURL = navigationModel.pdfURL
        self.action = navigationModel.action
    }

    public func addSavedFile(_ model: SavedFilesModel) {
        do {
            _ = try self.splitActionService.addSavedFile(model)
        } catch {
            print(error)
        }
    }
}
