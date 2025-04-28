//
//  SplitAssembly.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 28.04.25.
//

import Foundation
import PDFConverterViewModel
import Swinject
import SwinjectAutoregistration
import PDFConverterModel

final class SplitAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(ISplitViewModel.self, argument: PDFUrlNavigationModel.self, initializer: SplitViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(ISplitService.self, initializer: SplitService.init)
    }
}
