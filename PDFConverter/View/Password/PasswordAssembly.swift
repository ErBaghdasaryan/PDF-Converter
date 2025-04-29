//
//  PasswordAssembly.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 29.04.25.
//

import Foundation
import PDFConverterViewModel
import Swinject
import SwinjectAutoregistration
import PDFConverterModel

final class PasswordAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IPasswordViewModel.self, argument: PasswordNavigationModel.self, initializer: PasswordViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IPasswordService.self, initializer: PasswordService.init)
    }
}
