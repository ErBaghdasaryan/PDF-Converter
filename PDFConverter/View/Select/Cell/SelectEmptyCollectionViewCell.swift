//
//  SelectEmptyCollectionViewCell.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import UIKit
import Combine
import PDFConverterModel

class SelectEmptyCollectionViewCell: UICollectionViewCell, IReusableView {

    private let image = UIImageView(image: UIImage(named: "emptyImage"))
    private let header = UILabel(text: "Add a file",
                                 textColor: UIColor.black,
                                 font: UIFont(name: "SFProText-Bold", size: 32))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {

        self.backgroundColor = UIColor.clear

        self.addSubview(image)
        self.addSubview(header)
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
    }
}

