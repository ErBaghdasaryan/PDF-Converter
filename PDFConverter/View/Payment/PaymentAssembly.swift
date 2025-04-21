//
//  PaymentAssembly.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import Foundation
import PDFConverterViewModel
import Swinject
import SwinjectAutoregistration

final class PaymentAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IPaymentViewModel.self, initializer: PaymentViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IPaymentService.self, initializer: PaymentService.init)
    }
}
