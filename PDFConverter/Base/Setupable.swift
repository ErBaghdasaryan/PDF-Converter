//
//  Setupable.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import Foundation

protocol ISetupable {
    associatedtype SetupModel
    func setup(with model: SetupModel)
}
