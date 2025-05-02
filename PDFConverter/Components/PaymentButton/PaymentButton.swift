//
//  PaymentButton.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 17.04.25.
//
import UIKit
import PDFConverterModel

final class PaymentButton: UIButton {
    private let title = UILabel(text: "",
                                textColor: UIColor(hex: "#22242C")!,
                                font: UIFont(name: "SFProText-Bold", size: 18))
    private let count = UILabel(text: "",
                                      textColor: UIColor(hex: "#22242C")!,
                                      font: UIFont(name: "SFProText-Semibold", size: 12))
    private let saveLabel = UILabel(text: "Save 60%",
                                    textColor: .white,
                                    font: UIFont(name: "SFProText-Regular", size: 12))
    private let whiteLine = UIView()
    private let perDuration = UILabel(text: "",
                                      textColor: UIColor(hex: "#22242C")!,
                                      font: UIFont(name: "SFProText-Regular", size: 10))

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
        self.layer.cornerRadius = 12

        saveLabel.layer.masksToBounds = true
        saveLabel.layer.cornerRadius = 12
        saveLabel.backgroundColor =  UIColor(hex: "#232120")?.withAlphaComponent(0.7)

        self.whiteLine.backgroundColor = .white

        switch self.type {
        case .yearly:
            self.title.text = "Year"
            self.count.text = "Then 49.99 $"
            self.perDuration.text = "1 $ / Week"
            self.saveLabel.text = "Save 50%"

            addSubview(saveLabel)
        case .weekly:
            self.title.text = "Week"
            self.count.text = "Then 9.99 $"
            self.perDuration.text = "1.4 $ / Day"
        }

        self.isSelectedState = false

        addSubview(title)
        addSubview(count)
        addSubview(whiteLine)
        addSubview(perDuration)
        setupConstraints()
    }

    private func setupConstraints() {
        switch self.type {
        case .yearly:
            saveLabel.snp.makeConstraints { view in
                view.top.equalToSuperview().offset(12)
                view.leading.equalToSuperview().offset(55)
                view.trailing.equalToSuperview().inset(55)
                view.height.equalTo(24)
            }

            title.snp.makeConstraints { view in
                view.top.equalTo(saveLabel.snp.bottom).offset(8)
                view.leading.equalToSuperview().offset(12)
                view.trailing.equalToSuperview().inset(12)
                view.height.equalTo(18)
            }

        case .weekly:
            title.snp.makeConstraints { view in
                view.top.equalToSuperview().offset(28)
                view.leading.equalToSuperview().offset(12)
                view.trailing.equalToSuperview().inset(12)
                view.height.equalTo(18)
            }
        }

        count.snp.makeConstraints { view in
            view.top.equalTo(title.snp.bottom).offset(4)
            view.trailing.equalToSuperview().inset(12)
            view.leading.equalToSuperview().offset(12)
            view.height.equalTo(14)
        }

        whiteLine.snp.makeConstraints { view in
            view.top.equalTo(count.snp.bottom).offset(8)
            view.trailing.equalToSuperview().inset(14.5)
            view.leading.equalToSuperview().offset(14.5)
            view.height.equalTo(1)
        }

        perDuration.snp.makeConstraints { view in
            view.top.equalTo(whiteLine.snp.bottom).offset(8)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview().inset(12)
            view.height.equalTo(14)
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
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
        borderLayer.strokeColor = (isSelectedState ? UIColor(hex: "#232120")?.cgColor : UIColor.clear.cgColor)
        self.backgroundColor = isSelectedState ? UIColor.white : UIColor(hex: "#F1F1F1")!.withAlphaComponent(0.7)
        self.whiteLine.backgroundColor = isSelectedState ? UIColor(hex: "#232120")?.withAlphaComponent(0.7) : UIColor(hex: "#232120")?.withAlphaComponent(0.4)
    }

    func toggleSelection() {
        isSelectedState.toggle()
    }
}

enum PlanPresentationModel {
    case weekly
    case yearly
}
