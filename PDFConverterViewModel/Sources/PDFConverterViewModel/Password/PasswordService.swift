//
//  PasswordService.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 29.04.25.
//

import UIKit
import PDFConverterModel
import SQLite

public protocol IPasswordService {
    func updateSavedFile(_ model: SavedFilesModel) throws
}

public class PasswordService: IPasswordService {

    public init() { }

    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    typealias Expression = SQLite.Expression

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
