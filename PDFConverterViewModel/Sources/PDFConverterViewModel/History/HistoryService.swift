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
    func updateSavedFile(_ model: SavedFilesModel) throws
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
        let passwordColumn = Expression<String?>("password")

        try db.run(table.create(ifNotExists: true) { t in
            t.column(idColumn, primaryKey: .autoincrement)
            t.column(relativePathColumn)
            t.column(typeColumn)
            t.column(passwordColumn)
        })

        let relativePath = model.fileURL.lastPathComponent

        let rowId = try db.run(table.insert(
            relativePathColumn <- relativePath,
            typeColumn <- model.type.rawValue,
            passwordColumn <- model.password
        ))

        return SavedFilesModel(id: Int(rowId), pdfURL: model.fileURL, type: model.type, password: model.password)
    }

    public func getAllSavedFiles() throws -> [SavedFilesModel] {
        let db = try Connection("\(path)/db.sqlite3")
        let table = Table("SavedFiles")

        let idColumn = Expression<Int>("id")
        let relativePathColumn = Expression<String>("relative_path")
        let typeColumn = Expression<String>("type")
        let passwordColumn = Expression<String?>("password")

        var result: [SavedFilesModel] = []

        let baseDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        for row in try db.prepare(table) {
            if let pdfType = PDFType(rawValue: row[typeColumn]) {
                let relativePath = row[relativePathColumn]
                let fullURL = baseDirectory.appendingPathComponent(relativePath)
                let password = row[passwordColumn]

                let model = SavedFilesModel(
                    id: row[idColumn],
                    pdfURL: fullURL,
                    type: pdfType,
                    password: password
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

    public func updateSavedFile(_ model: SavedFilesModel) throws {
        guard let id = model.id else {
            throw NSError(domain: "Missing ID for update", code: 0)
        }

        let db = try Connection("\(path)/db.sqlite3")
        let table = Table("SavedFiles")

        let idColumn = Expression<Int>("id")
        let relativePathColumn = Expression<String>("relative_path")
        let typeColumn = Expression<String>("type")
        let passwordColumn = Expression<String?>("password")

        let itemToUpdate = table.filter(idColumn == id)

        let relativePath = model.fileURL.lastPathComponent

        try db.run(itemToUpdate.update(
            relativePathColumn <- relativePath,
            typeColumn <- model.type.rawValue,
            passwordColumn <- model.password
        ))
    }
}
