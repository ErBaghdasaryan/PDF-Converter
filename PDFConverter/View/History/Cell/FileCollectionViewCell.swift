//
//  FileCollectionViewCell.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 22.04.25.
//
import UIKit
import SnapKit
import Combine
import PDFConverterModel
import PDFKit

class FileCollectionViewCell: UICollectionViewCell, IReusableView {

    private let cyrcleView = UIView()
    private let image = UIImageView()
    private let titleLabel = UILabel(text: "",
                                     textColor: UIColor(hex: "#22242C")!,
                                     font: UIFont(name: "SFProText-Bold", size: 16))
    private let subTitleLabel = UILabel(text: "",
                                     textColor: UIColor(hex: "#22242C")!,
                                     font: UIFont(name: "SFProText-Regular", size: 12))
    private let pagesCount = UILabel(text: "",
                                     textColor: UIColor(hex: "#5F6E85")!,
                                     font: UIFont(name: "SFProText-Regular", size: 12))

    private var document: PDFDocument?

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

        cyrcleView.backgroundColor = .white
        cyrcleView.layer.cornerRadius = 32

        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 12
        self.image.contentMode = .scaleAspectFill

        self.titleLabel.textAlignment = .left
        self.subTitleLabel.textAlignment = .left
        self.pagesCount.textAlignment = .right

        contentView.addSubview(image)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(cyrcleView)
        contentView.addSubview(pagesCount)
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

        cyrcleView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(30)
            view.leading.equalTo(subTitleLabel.snp.trailing).offset(46)
            view.height.equalTo(65)
            view.width.equalTo(95)
        }

        pagesCount.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(8)
            view.trailing.equalToSuperview().inset(8)
            view.height.equalTo(14)
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
        case .pdfToText:
            image.image = UIImage(named: "PDFtoText")
            self.titleLabel.text = "PDF to Text"
            self.subTitleLabel.text = "Today"
        case .join:
            image.image = UIImage(named: "Join")
            self.titleLabel.text = "Join"
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
        default:
            break
        }

        self.document = PDFDocument(url: model.pdfURL)
        let pagesCount: Int = document?.pageCount ?? 0
        self.pagesCount.text = "\(pagesCount) pages"
    }
}

