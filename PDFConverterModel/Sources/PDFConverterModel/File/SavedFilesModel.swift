//
//  SavedFilesModel.swift
//  PDFConverterModel
//
//  Created by Er Baghdasaryan on 22.04.25.
//

import UIKit

public struct SavedFilesModel {
    public let id: Int?
    public let genre: String
    public let subGenre: String
    public let duration: String

    public init(id: Int? = nil, genre: String, subGenre: String, duration: String) {
        self.id = id
        self.genre = genre
        self.subGenre = subGenre
        self.duration = duration
    }
}
