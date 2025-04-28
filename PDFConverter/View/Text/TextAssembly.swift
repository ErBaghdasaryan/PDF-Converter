//
//  TextAssembly.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 28.04.25.
//

import Foundation
import PDFConverterViewModel
import Swinject
import SwinjectAutoregistration
import PDFConverterModel

final class TextAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(ITextViewModel.self, argument: PDFUrlNavigationModel.self, initializer: TextViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(ITextService.self, initializer: TextService.init)
    }
}
