//
//  MultiPartResponseModel.swift
//  PDFConverterModel
//
//  Created by Er Baghdasaryan on 29.04.25.
//
import Foundation

// MARK: - MultiPartResponseModel
public struct MultiPartResponseModel: Codable {
    public let id: UUID
    public let error: String?
}
