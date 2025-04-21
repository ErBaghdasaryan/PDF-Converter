//
//  SettingsViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import Foundation
import PDFConverterModel

public protocol ISettingsViewModel {
    var settingsItems: [[SettingsItem]] { get set }
    var sections: [SettingsSection] { get set }
    func loadData()
}

public class SettingsViewModel: ISettingsViewModel {

    private let settingsService: ISettingsService

    public var sections: [SettingsSection] = [.share, .setting, .info]
    public var settingsItems: [[SettingsItem]] = []

    public init(settingsService: ISettingsService) {
        self.settingsService = settingsService
    }

    public func loadData() {
        self.settingsItems = self.settingsService.getSettingsItems()
    }
}
