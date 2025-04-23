//
//  TabBarAssembly.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 23.04.25.
//
import Foundation
import PDFConverterViewModel
import Swinject
import SwinjectAutoregistration

final class TabBarAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(ITabBarViewModel.self, initializer: TabBarViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(ITabBarService.self, initializer: TabBarService.init)
    }
}
