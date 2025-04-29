//
//  CustomTextField.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 29.04.25.
//

import UIKit

public class CustomTextField: UITextField {

    private var isPassword: Bool = false

    public convenience init(placeholder: String, rightText: String? = nil) {
        self.init()
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
        self.layer.cornerRadius = 12
        self.backgroundColor = UIColor(hex: "#F9F9F9")
        self.textColor = UIColor(hex: "#5F6E85")
        self.font = UIFont(name: "SFProText-Regular", size: 14)

        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#5F6E85")!])

        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }

    public convenience init(passwordPlaceholder: String) {
        self.init()
        self.placeholder = passwordPlaceholder
        self.isSecureTextEntry = isSecureTextEntry
        self.layer.cornerRadius = 12
        self.backgroundColor = UIColor(hex: "#F9F9F9")
        self.textColor = UIColor(hex: "#56463D")
        self.font = UIFont(name: "SFProText-Semibold", size: 22)

        self.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#8E9DB5")!, NSAttributedString.Key.font: UIFont(name: "SFProText-Bold", size: 34)!] )

        self.autocorrectionType = .no
        self.autocapitalizationType = .none

        self.isPassword = true
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if isPassword {
            return bounds.insetBy(dx: 40, dy: 14)
        } else {
            return bounds.insetBy(dx: 12, dy: 0)
        }
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 32, dy: 0)
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 32, dy: 0)
    }
}
