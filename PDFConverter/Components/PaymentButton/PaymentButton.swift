//
//  PaymentButton.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//
import UIKit
import PDFConverterModel

final class PaymentButton: UIButton {

    private let selectImage = UIImageView(image: UIImage(named: "nonSelectedPayment"))
    private let title = UILabel(text: "",
                                textColor: UIColor(hex: "#5F6E85")!,
                                font: UIFont(name: "SFProText-Regular", size: 17))

    private let count = UILabel(text: "",
                                      textColor: UIColor(hex: "#5F6E85")!,
                                      font: UIFont(name: "SFProText-Regular", size: 11))
    private let saveLabel = UILabel(text: "SAVE 40%",
                                    textColor: .white,
                                    font: UIFont(name: "SFProText-Regular", size: 11))

    var isSelectedState: Bool {
        didSet {
            self.updateBorder()
        }
    }
    private var type: PlanPresentationModel
    private let borderLayer = CAShapeLayer()

    public init(type: PlanPresentationModel, isSelectedState: Bool = false) {
        self.type = type
        self.isSelectedState = isSelectedState
        super.init(frame: .zero)
        setupUI(type: type)
        self.setupBorder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }

    private func setupUI(type: PlanPresentationModel) {

        self.backgroundColor = UIColor(hex: "#F1F1F1")!.withAlphaComponent(0.7)
        self.layer.cornerRadius = 16

        saveLabel.layer.masksToBounds = true
        saveLabel.layer.cornerRadius = 14
        saveLabel.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner
        ]
        saveLabel.backgroundColor =  UIColor(hex: "#EC0D2A")

        self.title.textAlignment = .left
        self.count.textAlignment = .left

        switch self.type {
        case .yearly:
            self.title.text = "Just $49.99/Year"
            self.count.text = "Auto renewable. Cancel anytime."
            self.saveLabel.text = "SAVE 40%"

            addSubview(saveLabel)
        case .weekly:
            self.title.text = "Just $9.99/Week"
            self.count.text = "Auto renewable. Cancel anytime."
        }

        self.isSelectedState = false

        addSubview(selectImage)
        addSubview(title)
        addSubview(count)
        setupConstraints()
    }

    private func setupConstraints() {
        if self.type == .yearly {
            saveLabel.snp.makeConstraints { view in
                view.top.equalToSuperview()
                view.trailing.equalToSuperview()
                view.height.equalTo(21)
                view.width.equalTo(82)
            }
        }

        selectImage.snp.makeConstraints { view in
            view.centerY.equalToSuperview()
            view.leading.equalToSuperview().offset(12)
            view.width.equalTo(16)
            view.height.equalTo(16)
        }

        title.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalTo(selectImage.snp.trailing).offset(8)
            view.trailing.equalToSuperview().inset(8)
            view.height.equalTo(22)
        }

        count.snp.makeConstraints { view in
            view.top.equalTo(title.snp.bottom).offset(2)
            view.leading.equalTo(selectImage.snp.trailing).offset(8)
            view.trailing.equalToSuperview().inset(8)
            view.height.equalTo(13)
        }
    }

    public func setup(with isYearly: String) {
        self.title.text = isYearly
    }

    private func setupBorder() {
        borderLayer.lineWidth = 0.5
        borderLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(borderLayer)
        updateBorder()
    }

    private func updateBorder() {
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        borderLayer.strokeColor = (isSelectedState ? UIColor.white.cgColor : UIColor.clear.cgColor)
        self.backgroundColor = isSelectedState ? UIColor(hex: "#89817F") : UIColor(hex: "#F1F1F1")!.withAlphaComponent(0.7)
        self.selectImage.image = isSelectedState ? UIImage(named: "selectedPayment") : UIImage(named: "nonSelectedPayment")
        self.title.textColor = isSelectedState ? UIColor.white : UIColor(hex: "#5F6E85")
        self.count.textColor = isSelectedState ? UIColor.white.withAlphaComponent(0.4) : UIColor(hex: "#5F6E85")
    }

    func toggleSelection() {
        isSelectedState.toggle()
    }
}

enum PlanPresentationModel {
    case weekly
    case yearly
}
