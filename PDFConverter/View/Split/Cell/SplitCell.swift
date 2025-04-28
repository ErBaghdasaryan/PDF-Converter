//
//  SplitCell.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 28.04.25.
//

import UIKit
import PDFConverterModel

class SplitCell: UICollectionViewCell, IReusableView {

    private let title = UILabel()
    private let arrowImageView = UIImageView()

    func configure(with title: String) {
        self.title.text = title
        self.title.textColor = .black
        self.title.font = UIFont(name: "SFProText-Regular", size: 16)

        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .lightGray

        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(title)
        contentView.addSubview(arrowImageView)

        title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-8)
            make.height.equalTo(18)
        }

        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(title.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(8)
            make.height.equalTo(13)
        }

        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = UIColor(hex: "#F9F9F9")
    }
}
