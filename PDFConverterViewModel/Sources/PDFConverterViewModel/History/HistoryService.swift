//
//  HistoryService.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import UIKit
import PDFConverterModel
import SQLite

public protocol IHistoryService {
    func addSavedFile(_ model: SavedFilesModel) throws -> SavedFilesModel
    func getAllSavedFiles() throws -> [SavedFilesModel]
    func deleteSavedFile(by id: Int) throws
}

public class HistoryService: IHistoryService {

    public init() { }

    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    typealias Expression = SQLite.Expression

    public func addSavedFile(_ model: SavedFilesModel) throws -> SavedFilesModel {
        let db = try Connection("\(path)/db.sqlite3")
        let table = Table("SavedFiles")

        let idColumn = Expression<Int>("id")
        let relativePathColumn = Expression<String>("relative_path")
        let typeColumn = Expression<String>("type")

        try db.run(table.create(ifNotExists: true) { t in
            t.column(idColumn, primaryKey: .autoincrement)
            t.column(relativePathColumn)
            t.column(typeColumn)
        })

        let relativePath = model.fileURL.lastPathComponent

        let rowId = try db.run(table.insert(
            relativePathColumn <- relativePath,
            typeColumn <- model.type.rawValue
        ))

        return SavedFilesModel(id: Int(rowId), pdfURL: model.fileURL, type: model.type)
    }

    public func getAllSavedFiles() throws -> [SavedFilesModel] {
        let db = try Connection("\(path)/db.sqlite3")
        let table = Table("SavedFiles")

        let idColumn = Expression<Int>("id")
        let relativePathColumn = Expression<String>("relative_path")
        let typeColumn = Expression<String>("type")

        var result: [SavedFilesModel] = []

        let baseDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        for row in try db.prepare(table) {
            if let pdfType = PDFType(rawValue: row[typeColumn]) {
                let relativePath = row[relativePathColumn]
                let fullURL = baseDirectory.appendingPathComponent(relativePath)

                let model = SavedFilesModel(
                    id: row[idColumn],
                    pdfURL: fullURL,
                    type: pdfType
                )
                result.append(model)
            } else {
                print("❗ Неизвестный тип PDF: \(row[typeColumn])")
            }
        }

        return result
    }

    public func deleteSavedFile(by id: Int) throws {
        let db = try Connection("\(path)/db.sqlite3")
        let table = Table("SavedFiles")
        let idColumn = Expression<Int>("id")

        let itemToDelete = table.filter(idColumn == id)
        try db.run(itemToDelete.delete())
    }
}
