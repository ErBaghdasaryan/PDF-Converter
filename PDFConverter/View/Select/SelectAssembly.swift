//
//  SelectAssembly.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import Foundation
import PDFConverterViewModel
import Swinject
import SwinjectAutoregistration

final class SelectAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(ISelectViewModel.self, initializer: SelectViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IHistoryService.self, initializer: HistoryService.init)
    }
}
