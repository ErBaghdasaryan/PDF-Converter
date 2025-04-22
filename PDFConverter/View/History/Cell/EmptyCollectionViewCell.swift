//
//  EmptyCollectionViewCell.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 22.04.25.
//

import UIKit
import Combine
import PDFConverterModel

class EmptyCollectionViewCelll: UICollectionViewCell, IReusableView {

    private let image = UIImageView(image: UIImage(named: "emptyImage"))
    private let header = UILabel(text: "Go converte file",
                                 textColor: UIColor.black,
                                 font: UIFont(name: "SFProText-Bold", size: 32))
    private let add = UIButton(type: .system)
    public var addSubject = PassthroughSubject<Bool, Never>()
    var cancellables = Set<AnyCancellable>()

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let gradientLayer = add.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = add.bounds
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeButtonActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        makeButtonActions()
    }

    private func setupUI() {

        self.backgroundColor = UIColor.clear

        self.add.setTitle("Go converte", for: .normal)
        self.add.setTitleColor(.white, for: .normal)
        self.add.layer.cornerRadius = 12
        self.add.layer.masksToBounds = true
        self.add.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)

        let buttonGradient = CAGradientLayer()
        buttonGradient.colors = [
            UIColor(hex: "#232120")!.cgColor,
            UIColor(hex: "#565150")!.cgColor,
            UIColor(hex: "#89817F")!.cgColor
        ]
        buttonGradient.startPoint = CGPoint(x: 0, y: 0.5)
        buttonGradient.endPoint = CGPoint(x: 1, y: 0.5)
        buttonGradient.locations = [0.0, 0.5, 1.0]
        buttonGradient.cornerRadius = 20
        add.layer.insertSublayer(buttonGradient, at: 0)

        self.addSubview(image)
        self.addSubview(header)
        self.addSubview(add)
        setupConstraints()
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(115)
            view.centerX.equalToSuperview()
            view.height.equalTo(150)
            view.width.equalTo(136)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(image.snp.bottom).offset(25)
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(34)
        }

        add.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(56)
            view.trailing.equalToSuperview().inset(56)
            view.height.equalTo(44)
        }
    }
}

extension EmptyCollectionViewCelll {
    private func makeButtonActions() {
        self.add.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }

    @objc func addTapped() {
        self.addSubject.send(true)
    }
}
