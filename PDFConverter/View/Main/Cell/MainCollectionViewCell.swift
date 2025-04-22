//
//  MainCollectionViewCell.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 22.04.25.
//

import UIKit
import SnapKit
import PDFConverterModel

final class MainCollectionViewCell: UICollectionViewCell, IReusableView {

    private var image = UIImageView()
    private let header = UILabel(text: "",
                                 textColor: UIColor.black,
                                 font: UIFont(name: "SFProText-Regular", size: 12))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        self.addSubview(image)
        self.addSubview(header)
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview().inset(18)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(image.snp.bottom).offset(4)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
    }

    public func setup(model: MainItem) {
        self.image.image = model.icon
        self.header.text = model.title
    }
}
