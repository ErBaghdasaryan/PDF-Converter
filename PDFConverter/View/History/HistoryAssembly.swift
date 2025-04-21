//
//  HistoryAssembly.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import Foundation
import PDFConverterViewModel
import Swinject
import SwinjectAutoregistration

final class HistoryAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IHistoryViewModel.self, initializer: HistoryViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IHistoryService.self, initializer: HistoryService.init)
    }
}
