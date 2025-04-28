//
//  UIImage.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//

import UIKit

public extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized ?? self
    }

    func toPDF() -> URL? {
        let pdfMetaData = [
            kCGPDFContextCreator: "MyApp",
            kCGPDFContextAuthor: "YourName"
        ]

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = self.size.width
        let pageHeight = self.size.height
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let fileName = UUID().uuidString + ".pdf"
        let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = docsDir.appendingPathComponent(fileName)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        do {
            try renderer.writePDF(to: url) { context in
                context.beginPage()
                self.draw(in: pageRect)
            }
            print("PDF saved to: \(url)")
            return url
        } catch {
            print("Error saving PDF: \(error)")
            return nil
        }
    }

    static func imageFrom(text: String, font: UIFont, textColor: UIColor, backgroundColor: UIColor = .clear, size: CGSize = CGSize(width: 300, height: 100)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            attributedString.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
