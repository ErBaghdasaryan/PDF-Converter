//
//  PaymentViewModel.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 17.04.25.
//
import Foundation
import PDFConverterModel

public protocol IPaymentViewModel {

}

public class PaymentViewModel: IPaymentViewModel {

    private let paymentService: IPaymentService

    public init(paymentService: IPaymentService) {
        self.paymentService = paymentService
    }
}
