//
//  TabBarViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 23.04.25.
//

import Foundation
import PDFConverterModel

public protocol ITabBarViewModel {
    func addSavedFile(_ model: SavedFilesModel)
}

public class TabBarViewModel: ITabBarViewModel {

    private let tabBarService: ITabBarService

    public init(tabBarService: ITabBarService) {
        self.tabBarService = tabBarService
    }

    public func addSavedFile(_ model: SavedFilesModel) {
        do {
            _ = try self.tabBarService.addSavedFile(model)
        } catch {
            print(error)
        }
    }
}
