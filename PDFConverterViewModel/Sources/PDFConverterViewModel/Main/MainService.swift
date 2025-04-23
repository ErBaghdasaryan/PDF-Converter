//
//  MainService.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import UIKit
import PDFConverterModel
import SQLite

public protocol IMainService {
    func getMainItems() -> [[MainItem]]
    func addSavedFile(_ model: SavedFilesModel) throws -> SavedFilesModel
}

public class MainService: IMainService {

    public init() { }

    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    typealias Expression = SQLite.Expression

    public func addSavedFile(_ model: SavedFilesModel) throws -> SavedFilesModel {
        let db = try Connection("\(path)/db.sqlite3")
        let table = Table("SavedFiles")

        let idColumn = Expression<Int>("id")
        let pdfURLColumn = Expression<String>("pdf_url")
        let typeColumn = Expression<String>("type")

        try db.run(table.create(ifNotExists: true) { t in
            t.column(idColumn, primaryKey: .autoincrement)
            t.column(pdfURLColumn)
            t.column(typeColumn)
        })

        let rowId = try db.run(table.insert(
            pdfURLColumn <- model.pdfURL.path,
            typeColumn <- model.type.rawValue
        ))

        return SavedFilesModel(id: Int(rowId), pdfURL: model.pdfURL, type: model.type)
    }

    public func getMainItems() -> [[MainItem]] {
        [
            [
                MainItem(icon: UIImage(named: "WordToPDF"), title: "Word to PDF"),
                MainItem(icon: UIImage(named: "ExelToPDF"), title: "Exel to PDF"),
                MainItem(icon: UIImage(named: "PDF"), title: "PDF"),
                MainItem(icon: UIImage(named: "PDFtoText"), title: "PDF to text"),
                MainItem(icon: UIImage(named: "Join"), title: "Join"),
                MainItem(icon: UIImage(named: "ImageToPDF"), title: "Image to PDF"),
                MainItem(icon: UIImage(named: "PointToPDF"), title: "Point to PDF"),
                MainItem(icon: UIImage(named: "Split"), title: "Split"),
            ],
            [
                MainItem(icon: UIImage(named: "WordToPDF"), title: "Word to PDF"),
                MainItem(icon: UIImage(named: "ExelToPDF"), title: "Exel to PDF"),
                MainItem(icon: UIImage(named: "PDF"), title: "PDF"),
                MainItem(icon: UIImage(named: "PDFtoDOC"), title: "PDF to DOC"),
                MainItem(icon: UIImage(named: "Join"), title: "Join"),
                MainItem(icon: UIImage(named: "ImageToPDF"), title: "Image to PDF"),
                MainItem(icon: UIImage(named: "PointToPDF"), title: "PPT to PDF"),
                MainItem(icon: UIImage(named: "Split"), title: "Split"),
                MainItem(icon: UIImage(named: "JPEGtoPDF"), title: "JPEG to PDF"),
                MainItem(icon: UIImage(named: "TXTtoPDF"), title: "Txt to Image"),
                MainItem(icon: UIImage(named: "PNGtoPDF"), title: "PNG to PDF"),
                MainItem(icon: UIImage(named: "signature"), title: "Signature"),
            ]
        ]
    }
}
