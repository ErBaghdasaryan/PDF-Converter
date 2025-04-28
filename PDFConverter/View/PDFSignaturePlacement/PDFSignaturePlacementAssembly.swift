//
//  PDFSignaturePlacementAssembly.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import Foundation
import PDFConverterViewModel
import Swinject
import SwinjectAutoregistration
import PDFConverterModel

final class PDFSignaturePlacementAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IPDFSignaturePlacementViewModel.self, argument: PDFSignaturePlacementServiceNavModel.self, initializer: PDFSignaturePlacementViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IPDFSignaturePlacementService.self, initializer: PDFSignaturePlacementService.init)
    }
}
