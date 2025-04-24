//
//  SelectViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import Foundation
import PDFConverterModel

public protocol ISelectViewModel {
    var savedFiles: [SavedFilesModel] { get set }
    func loadFiles()
    func deleteSavedFile(by id: Int)
}

public class SelectViewModel: ISelectViewModel {

    private let historyService: IHistoryService

    public var savedFiles: [SavedFilesModel] = []

    public init(historyService: IHistoryService) {
        self.historyService = historyService
    }

    public func loadFiles() {
        do {
            self.savedFiles = try self.historyService.getAllSavedFiles()
        } catch {
            print(error)
        }
    }

    public func deleteSavedFile(by id: Int) {
        do {
            try self.historyService.deleteSavedFile(by: id)
        } catch {
            print(error)
        }
    }
}
