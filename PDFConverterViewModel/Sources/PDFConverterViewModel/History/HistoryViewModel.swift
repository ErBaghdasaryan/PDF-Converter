//
//  HistoryViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import Foundation
import PDFConverterModel

public protocol IHistoryViewModel {
    var savedFiles: [SavedFilesModel] { get set }
    func loadFiles()
}

public class HistoryViewModel: IHistoryViewModel {

    private let historyService: IHistoryService

    public var savedFiles: [SavedFilesModel] = []

    public init(historyService: IHistoryService) {
        self.historyService = historyService
    }

    public func loadFiles() {
//        do {
//            self.savedMusics = try self.historyService.getAllSavedMusics()
//        } catch {
//            print(error)
//        }
    }
}
