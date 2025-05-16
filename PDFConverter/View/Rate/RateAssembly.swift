//
//  RateAssembly.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 16.05.25.
//

import Foundation
import PDFConverterViewModel
import Swinject
import SwinjectAutoregistration

final class RateAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IRateViewModel.self, initializer: RateViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IRateService.self, initializer: RateService.init)
    }
}
