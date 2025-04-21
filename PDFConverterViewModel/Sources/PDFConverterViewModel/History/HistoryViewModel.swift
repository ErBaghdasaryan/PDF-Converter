//
//  HistoryViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import Foundation
import PDFConverterModel

public protocol IHistoryViewModel {

}

public class HistoryViewModel: IHistoryViewModel {

    private let historyService: IHistoryService

    public init(historyService: IHistoryService) {
        self.historyService = historyService
    }
}
