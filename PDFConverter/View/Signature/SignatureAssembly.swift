//
//  SignatureAssembly.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import Foundation
import PDFConverterViewModel
import Swinject
import SwinjectAutoregistration
import PDFConverterModel

final class SignatureAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(ISignatureViewModel.self, argument: PDFUrlNavigationModel.self, initializer: SignatureViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(ISignatureService.self, initializer: SignatureService.init)
    }
}
