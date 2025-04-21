//
//  OnboardingService.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import UIKit
import PDFConverterModel

public protocol IOnboardingService {
    func getOnboardingItems() -> [OnboardingPresentationModel]
}

public class OnboardingService: IOnboardingService {
    public init() { }

    public func getOnboardingItems() -> [OnboardingPresentationModel] {
        [
            OnboardingPresentationModel(image: "onboarding1",
                                        header: "Welcome to PDF Photo Converter",
                                        subheader: "Convert PDF to images or create PDF from photos with ease!"),
            OnboardingPresentationModel(image: "onboarding2",
                                        header: "Create a single PDF file from anything!",
                                        subheader: ""),
            OnboardingPresentationModel(image: "onboarding3",
                                        header: "Help us become better!",
                                        subheader: "We value your opinion. Leave a review about our application to help other users learn about its capabilities.")
        ]
    }
}
