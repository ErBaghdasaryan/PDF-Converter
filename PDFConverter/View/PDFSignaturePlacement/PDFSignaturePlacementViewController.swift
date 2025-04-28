//
//  PDFSignaturePlacementViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import UIKit
import PDFKit
import SnapKit
import PDFConverterViewModel

final class PDFSignaturePlacementViewController: BaseViewController {

    var viewModel: ViewModel?

    var pdfURL: URL!
    var signatureImage: UIImage!
    var isText: Bool!

    private let pdfView = PDFView()
    private let signatureImageView = UIImageView()
    private let saveButton = UIButton(type: .system)

    private var signatureScale: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPDF()
        setupSignatureView()
        setupGestures()
        setupSaveButton()
    }

    override func setupUI() {
        super.setupUI()
        self.title = "Place Signature"
        self.view.backgroundColor = .white

        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
        self.pdfURL = self.viewModel?.pdfURL
        self.signatureImage = self.viewModel?.signatureImage
        self.isText = self.viewModel?.isText
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let gradientLayer = saveButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = saveButton.bounds
        }
    }

    private func setupPDF() {
        pdfView.autoScales = true
        pdfView.backgroundColor = .white
        pdfView.document = PDFDocument(url: pdfURL)
        self.view.addSubview(pdfView)

        pdfView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(108)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview().inset(110)
        }
    }

    private func setupSignatureView() {
        signatureImageView.image = signatureImage
        signatureImageView.isUserInteractionEnabled = true
        signatureImageView.contentMode = .scaleAspectFit
        signatureImageView.frame = CGRect(x: 100, y: 200, width: 150, height: 75)
        view.addSubview(signatureImageView)
    }

    private func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        signatureImageView.addGestureRecognizer(pan)
        signatureImageView.addGestureRecognizer(pinch)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if let gestureView = gesture.view {
            gestureView.center = CGPoint(x: gestureView.center.x + translation.x,
                                         y: gestureView.center.y + translation.y)
        }
        gesture.setTranslation(.zero, in: view)
    }

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else { return }

        if gesture.state == .began || gesture.state == .changed {
            gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            signatureScale *= gesture.scale
            gesture.scale = 1
        }
    }

    private func setupSaveButton() {
        self.saveButton.setTitle("Next", for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.layer.cornerRadius = 12
        self.saveButton.layer.masksToBounds = true
        self.saveButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)
        view.addSubview(saveButton)

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
        saveButton.layer.insertSublayer(buttonGradient, at: 0)

        saveButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(50)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(44)
        }

        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    @objc private func saveTapped() {
        guard let document = pdfView.document,
              let page = document.page(at: 0) else { return }

        let rendererBounds = page.bounds(for: .mediaBox)

        let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = UUID().uuidString + ".pdf"
        let filePath = docsDir.appendingPathComponent(fileName)

        UIGraphicsBeginPDFContextToFile(filePath.path, rendererBounds, nil)
        UIGraphicsBeginPDFPageWithInfo(rendererBounds, nil)

        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.saveGState()
            ctx.translateBy(x: 0, y: rendererBounds.height)
            ctx.scaleBy(x: 1, y: -1)
            page.draw(with: .mediaBox, to: ctx)
            ctx.restoreGState()

            let convertedFrame = view.convert(signatureImageView.frame, to: pdfView)
            let imageBounds = pdfView.convert(convertedFrame, to: page)

            var correctedImageBounds = imageBounds
            correctedImageBounds.origin.y = rendererBounds.height - imageBounds.origin.y - imageBounds.height

            signatureImage.draw(in: correctedImageBounds)
        }

        UIGraphicsEndPDFContext()

        let signedURL = filePath

        if self.isText {
            self.viewModel?.addSavedFile(.init(pdfURL: signedURL, type: .textToImage))
            self.showSuccessAlert(message: "Your text has been added and saved. Check it in the 'History' section.") {
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first?.delegate as? SceneDelegate {
                    sceneDelegate.startTabBarFlow()
                }
            }
        } else {
            self.viewModel?.addSavedFile(.init(pdfURL: signedURL, type: .signature))
            self.showSuccessAlert(message: "Your signature has been added and saved. Check it in the 'History' section.") {
                if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first?.delegate as? SceneDelegate {
                    sceneDelegate.startTabBarFlow()
                }
            }
        }
    }

    private func setupNavigationItems() {
        let button1 = UIButton(type: .custom)
        button1.setImage(UIImage(named: "ntfBack"), for: .normal)
        button1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button1.addTarget(self, action: #selector(customBackFunctionality), for: .touchUpInside)

        let leftButton = UIBarButtonItem(customView: button1)

        navigationItem.leftBarButtonItem = leftButton
    }

    @objc func customBackFunctionality() {
        guard let navigationController = self.navigationController else { return }

        navigationController.popViewController(animated: true)
    }
}

extension PDFSignaturePlacementViewController: IViewModelableController {
    typealias ViewModel = IPDFSignaturePlacementViewModel
}

//MARK: Preview
import SwiftUI

struct PDFSignaturePlacementViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let pDFSignaturePlacementViewController = PDFSignaturePlacementViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<PDFSignaturePlacementViewControllerProvider.ContainerView>) -> PDFSignaturePlacementViewController {
            return pDFSignaturePlacementViewController
        }

        func updateUIViewController(_ uiViewController: PDFSignaturePlacementViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PDFSignaturePlacementViewControllerProvider.ContainerView>) {
        }
    }
}
