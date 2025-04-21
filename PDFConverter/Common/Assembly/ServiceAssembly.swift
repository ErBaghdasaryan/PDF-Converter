//
//  ServiceAssembly.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import PDFConverterViewModel

public final class ServiceAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.autoregister(IKeychainService.self, initializer: KeychainService.init)
        container.autoregister(IAppStorageService.self, initializer: AppStorageService.init)
        container.autoregister(INetworkService.self, initializer: NetworkService.init)
    }
}
