//
//  TabBarService.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 23.04.25.
//

import UIKit
import PDFConverterModel
import SQLite

public protocol ITabBarService {
    func addSavedFile(_ model: SavedFilesModel) throws -> SavedFilesModel
}

public class TabBarService: ITabBarService {

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

        let relativePath = model.pdfURL.lastPathComponent

        let rowId = try db.run(table.insert(
            relativePathColumn <- relativePath,
            typeColumn <- model.type.rawValue
        ))

        return SavedFilesModel(id: Int(rowId), pdfURL: model.pdfURL, type: model.type)
    }
}
