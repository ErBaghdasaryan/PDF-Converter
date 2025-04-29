//
//  CustomTextField.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 29.04.25.
//

import UIKit

public class CustomTextField: UITextField {

    public convenience init(placeholder: String, rightText: String? = nil) {
        self.init()
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
        self.layer.cornerRadius = 12
        self.backgroundColor = .clear
        self.textColor = UIColor(hex: "#5F6E85")
        self.font = UIFont(name: "SFProText-Regular", size: 14)

        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#5F6E85")!])

        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 12, dy: 0)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 12, dy: 0)
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 12, dy: 0)
    }
}
