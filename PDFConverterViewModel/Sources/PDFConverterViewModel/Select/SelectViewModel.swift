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
    var type: PDFType { get }
    func addSavedFile(_ model: SavedFilesModel)
}

public class SelectViewModel: ISelectViewModel {

    private let historyService: IHistoryService

    public var savedFiles: [SavedFilesModel] = []

    public var type: PDFType

    public init(historyService: IHistoryService,
                navigationModel: SelectNavigationModel) {
        self.historyService = historyService
        self.type = navigationModel.type
    }

    public func addSavedFile(_ model: SavedFilesModel) {
        do {
            _ = try self.historyService.addSavedFile(model)
        } catch {
            print(error)
        }
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
