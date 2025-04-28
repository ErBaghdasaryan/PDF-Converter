//
//  SelectFileCollectionViewCell.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import UIKit
import SnapKit
import Combine
import PDFConverterModel
import PDFKit

class SelectFileCollectionViewCell: UICollectionViewCell, IReusableView {

    private let image = UIImageView()
    private let titleLabel = UILabel(text: "",
                                     textColor: UIColor(hex: "#22242C")!,
                                     font: UIFont(name: "SFProText-Bold", size: 16))
    private let subTitleLabel = UILabel(text: "",
                                     textColor: UIColor(hex: "#22242C")!,
                                     font: UIFont(name: "SFProText-Regular", size: 12))
    private let selectImage = UIImageView(image: UIImage(named: "nonSelectedFIle"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = UIColor(hex: "#F9F9F9")
        layer.cornerRadius = 12

        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 12
        self.image.contentMode = .scaleAspectFill

        self.titleLabel.textAlignment = .left
        self.subTitleLabel.textAlignment = .left

        contentView.addSubview(image)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(selectImage)
        setupConstraints()
    }

    private func setupConstraints() {

        image.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.height.equalTo(65)
            view.width.equalTo(65)
        }

        titleLabel.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(14)
            view.leading.equalTo(image.snp.trailing).offset(12)
            view.trailing.equalToSuperview().inset(105)
            view.height.equalTo(18)
        }

        subTitleLabel.snp.makeConstraints { view in
            view.top.equalTo(titleLabel.snp.bottom).offset(4)
            view.leading.equalTo(image.snp.trailing).offset(12)
            view.trailing.equalToSuperview().inset(105)
            view.height.equalTo(14)
        }

        selectImage.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(20.5)
            view.trailing.equalToSuperview().inset(12)
            view.height.equalTo(24)
            view.width.equalTo(24)
        }
    }

    func configure(model: SavedFilesModel) {
        switch model.type {
        case .wordToPDF:
            image.image = UIImage(named: "WordToPDF")
            self.titleLabel.text = "Word to PDF"
            self.subTitleLabel.text = "Today"
        case .exelToPDF:
            image.image = UIImage(named: "ExelToPDF")
            self.titleLabel.text = "Exel to PDF"
            self.subTitleLabel.text = "Today"
        case .pdf:
            image.image = UIImage(named: "PDF")
            self.titleLabel.text = "PDF"
            self.subTitleLabel.text = "Today"
        case .imageToPDF:
            image.image = UIImage(named: "ImageToPDF")
            self.titleLabel.text = "Image to PDF"
            self.subTitleLabel.text = "Today"
        case .pointToPdf:
            image.image = UIImage(named: "PointToPDF")
            self.titleLabel.text = "Point to PDF"
            self.subTitleLabel.text = "Today"
        case .split:
            image.image = UIImage(named: "Split")
            self.titleLabel.text = "Split"
            self.subTitleLabel.text = "Today"
        case .pdfToDoc:
            image.image = UIImage(named: "PDFtoDOC")
            self.titleLabel.text = "PDF to DOC"
            self.subTitleLabel.text = "Today"
        case .signature:
            image.image = UIImage(named: "signature")
            self.titleLabel.text = "Signature"
            self.subTitleLabel.text = "Today"
        case .textToImage:
            image.image = UIImage(named: "TXTtoPDF")
            self.titleLabel.text = "Text to image"
            self.subTitleLabel.text = "Today"
        case .jpegToPDF:
            image.image = UIImage(named: "JPEGtoPDF")
            self.titleLabel.text = "Jpeg to PDF"
            self.subTitleLabel.text = "Today"
        case .pngToPdf:
            image.image = UIImage(named: "PNGtoPDF")
            self.titleLabel.text = "Png to PDF"
            self.subTitleLabel.text = "Today"
        }
    }

    func updateSelectionState(isSelected: Bool) {
        self.selectImage.image = isSelected ? UIImage(named: "selectedFile") : UIImage(named: "nonSelectedFIle")
    }
}
