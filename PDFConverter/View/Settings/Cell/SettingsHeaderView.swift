//
//  SettingsHeaderView.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 21.04.25.
//


import UIKit
import SnapKit
import PDFConverterModel

class SettingsHeaderView: UICollectionReusableView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "SFProText-Semibold", size: 18)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: SettingsSection) {
        switch model {
        case .info:
            titleLabel.text = "Info & Legal"
        case .setting:
            titleLabel.text = "Settings"
        case .share:
            titleLabel.text = "Share"
        }
    }
}
