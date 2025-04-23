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
    func getAllSavedFiles() throws -> [SavedFilesModel]
    func deleteSavedFile(by id: Int) throws
}

public class HistoryService: IHistoryService {

    public init() { }

    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    typealias Expression = SQLite.Expression

    public func getAllSavedFiles() throws -> [SavedFilesModel] {
        let db = try Connection("\(path)/db.sqlite3")
        let table = Table("SavedFiles")

        let idColumn = Expression<Int>("id")
        let pdfURLColumn = Expression<String>("pdf_url")
        let typeColumn = Expression<String>("type")

        var result: [SavedFilesModel] = []

        for row in try db.prepare(table) {
            if let pdfType = PDFType(rawValue: row[typeColumn]) {
                let url = URL(fileURLWithPath: row[pdfURLColumn])
                let model = SavedFilesModel(
                    id: row[idColumn],
                    pdfURL: url,
                    type: pdfType
                )
                result.append(model)

            } else {
                print("Неизвестный тип PDF: \(row[typeColumn])")
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
