//
//  SplitActionAssembly.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 29.04.25.
//

import Foundation
import PDFConverterViewModel
import Swinject
import SwinjectAutoregistration
import PDFConverterModel

final class SplitActionAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(ISplitActionViewModel.self, argument: SplitActionNavigationModel.self, initializer: SplitActionViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(ISplitActionService.self, initializer: SplitActionService.init)
    }
}
