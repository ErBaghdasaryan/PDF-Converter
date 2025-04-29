//
//  FileIDResponseModel.swift
//  PDFConverterModel
//
//  Created by Er Baghdasaryan on 29.04.25.
//
import Foundation

//MARK: FileIDResponseModel
public struct FileIDResponseModel: Codable {
    public let id: UUID
    public let error: String?
    public let items: [FileItem]
}

// MARK: - FileItem
public struct FileItem: Codable {
    public let id: Int
    public let filename: String
}
