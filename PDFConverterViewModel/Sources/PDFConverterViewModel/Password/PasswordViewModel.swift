//
//  PasswordViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 29.04.25.
//

import Foundation
import PDFConverterModel

public protocol IPasswordViewModel {
    var model: SavedFilesModel { get }
    func updateSavedFile(_ model: SavedFilesModel)
}

public class PasswordViewModel: IPasswordViewModel {

    private let passwordService: IPasswordService

    public var model: SavedFilesModel

    public init(passwordService: IPasswordService,
                navigationModel: PasswordNavigationModel) {
        self.passwordService = passwordService
        self.model = navigationModel.model
    }

    public func updateSavedFile(_ model: SavedFilesModel) {
        do {
            try self.passwordService.updateSavedFile(model)
        } catch {
            print(error)
        }
    }
}
