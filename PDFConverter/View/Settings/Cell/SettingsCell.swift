//
//  SettingsCell.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import UIKit
import PDFConverterModel

class SettingsCell: UICollectionViewCell, IReusableView {

    private let icon = UIImageView()
    private let title = UILabel()

    func configure(with item: SettingsItem) {
        icon.image = item.icon
        title.text = item.title

        icon.tintColor = .white
        title.textColor = .black
        title.font = UIFont(name: "SFProText-Regular", size: 16)

        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(icon)
        contentView.addSubview(title)

        icon.frame = CGRect(x: 12, y: 16, width: 20, height: 20)
        title.frame = CGRect(x: 44, y: 16, width: contentView.frame.width - 56, height: 20)

        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = UIColor(hex: "#F9F9F9")
    }
}
