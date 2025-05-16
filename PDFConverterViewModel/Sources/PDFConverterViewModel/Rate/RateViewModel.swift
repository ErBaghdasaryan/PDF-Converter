//
//  RateViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 16.05.25.
//

import Foundation
import PDFConverterModel

public protocol IRateViewModel {

}

public class RateViewModel: IRateViewModel {

    private let rateService: IRateService

    public init(rateService: IRateService) {
        self.rateService = rateService
    }
}
