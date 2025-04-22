//
//  MainService.swift
//  PDFConverterViewModel
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import UIKit
import PDFConverterModel

public protocol IMainService {
    func getMainItems() -> [[MainItem]]
}

public class MainService: IMainService {
    public init() { }

    public func getMainItems() -> [[MainItem]] {
        [
            [
                MainItem(icon: UIImage(named: "WordToPDF"), title: "Word to PDF"),
                MainItem(icon: UIImage(named: "ExelToPDF"), title: "Exel to PDF"),
                MainItem(icon: UIImage(named: "PDF"), title: "PDF"),
                MainItem(icon: UIImage(named: "PDFtoText"), title: "PDF to text"),
                MainItem(icon: UIImage(named: "Join"), title: "Join"),
                MainItem(icon: UIImage(named: "ImageToPDF"), title: "Image to PDF"),
                MainItem(icon: UIImage(named: "PointToPDF"), title: "Point to PDF"),
                MainItem(icon: UIImage(named: "Split"), title: "Split"),
            ],
            [
                MainItem(icon: UIImage(named: "WordToPDF"), title: "Word to PDF"),
                MainItem(icon: UIImage(named: "ExelToPDF"), title: "Exel to PDF"),
                MainItem(icon: UIImage(named: "PDF"), title: "PDF"),
                MainItem(icon: UIImage(named: "PDFtoDOC"), title: "PDF to DOC"),
                MainItem(icon: UIImage(named: "Join"), title: "Join"),
                MainItem(icon: UIImage(named: "ImageToPDF"), title: "Image to PDF"),
                MainItem(icon: UIImage(named: "PointToPDF"), title: "PPT to PDF"),
                MainItem(icon: UIImage(named: "Split"), title: "Split"),
                MainItem(icon: UIImage(named: "JPEGtoPDF"), title: "JPEG to PDF"),
                MainItem(icon: UIImage(named: "TXTtoPDF"), title: "Txt to Image"),
                MainItem(icon: UIImage(named: "PNGtoPDF"), title: "PNG to PDF"),
                MainItem(icon: UIImage(named: "HFIFtoPDF"), title: "HFIF to PDF"),
            ]
        ]
    }
}
