//
//  MainViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import Foundation
import PDFConverterModel

public protocol IMainViewModel {

}

public class MainViewModel: IMainViewModel {

    private let mainService: IMainService

    public init(mainService: IMainService) {
        self.mainService = mainService
    }
}
