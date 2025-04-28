//
//  SignatureView.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 24.04.25.
//
import UIKit

class SignatureView: UIView {

    private let path = UIBezierPath()
    private var previousPoint: CGPoint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = false
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isMultipleTouchEnabled = false
        backgroundColor = .clear
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        previousPoint = touch.location(in: self)
        path.move(to: previousPoint!)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let previous = previousPoint else { return }
        let currentPoint = touch.location(in: self)
        path.addLine(to: currentPoint)
        previousPoint = currentPoint
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        path.lineWidth = 2.0
        path.stroke()
    }

    func getSignatureImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return signature ?? UIImage()
    }

    func clear() {
        path.removeAllPoints()
        setNeedsDisplay()
    }
}
