//
//  MainViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import Foundation
import PDFConverterModel

public protocol IMainViewModel {
    var mainItems: [[MainItem]] { get set }
    var sections: [MainSection] { get set }
    func loadData()
}

public class MainViewModel: IMainViewModel {

    private let mainService: IMainService

    public var sections: [MainSection] = [.popular, .other]
    public var mainItems: [[MainItem]] = []

    public init(mainService: IMainService) {
        self.mainService = mainService
    }

    public func loadData() {
        self.mainItems = self.mainService.getMainItems()
    }
}
