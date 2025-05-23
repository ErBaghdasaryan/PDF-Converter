//
//  TabBarViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 21.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import PDFKit

class TabBarViewController: UITabBarController {

    var viewModel: ViewModel?

    private let cameraButton = UIButton(type: .system)
    private let borderLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
        setupCameraButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTabBarBorderLayer()
    }

    // MARK: - Deinit
    deinit {
        #if DEBUG
        print("deinit \(String(describing: self))")
        #endif
    }
}

extension TabBarViewController: IViewModelableController {
    typealias ViewModel = ITabBarViewModel
}

//MARK: Setups
extension TabBarViewController {

    private func setupViewControllers() {
        lazy var mainViewController = self.createNavigation(title: "Main",
                                                            image: "main",
                                                            vc: ViewControllerFactory.makeMainViewController())

        lazy var historyViewController = self.createNavigation(title: "History",
                                                               image: "history",
                                                               vc: ViewControllerFactory.makeHistoryViewController())

        self.setViewControllers([mainViewController, historyViewController], animated: true)

        mainViewController.delegate = self
        historyViewController.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(setPageToFirst), name: Notification.Name("setPageToMain"), object: nil)
    }

    private func createNavigation(title: String, image: String, vc: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: vc)
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.itemPositioning = .fill

        let nonselectedTitleColor: UIColor = UIColor(hex: "#8E9DB5")!
        let selectedTitleColor: UIColor = UIColor(hex: "#56463D")!

        let unselectedImage = UIImage(named: image)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(nonselectedTitleColor)

        let selectedImage = UIImage(named: image)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(selectedTitleColor)

        navigation.tabBarItem.image = unselectedImage
        navigation.tabBarItem.selectedImage = selectedImage
        navigation.tabBarItem.title = title

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: nonselectedTitleColor
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedTitleColor
        ]

        navigation.tabBarItem.setTitleTextAttributes(normalAttributes, for: .normal)
        navigation.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)

        return navigation
    }

    private func setupCameraButton() {
        self.cameraButton.setImage(UIImage(named: "cameraButton"), for: .normal)

        self.cameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        self.tabBar.addSubview(cameraButton)

        cameraButton.snp.makeConstraints { view in
            view.centerX.equalToSuperview()
            view.height.width.equalTo(64)
            view.top.equalTo(self.tabBar.snp.top).offset(-12)
        }
    }
}

//MARK: Navigation & TabBar Hidden
extension TabBarViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.hidesBottomBarWhenPushed {
            self.tabBar.isHidden = true
        } else {
            self.tabBar.isHidden = false
        }
    }
}

//MARK: ImagePicker
extension TabBarViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let pdfURL = image.toPDF() {
                self.viewModel?.addSavedFile(.init(pdfURL: pdfURL, type: .imageToPDF))

                self.showSuccessAlert(message: "The image you took has been converted to pdf and is in the 'History' section.")
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: Functionality
extension TabBarViewController {

    @objc private func openCamera() {
        let defaults = UserDefaults.standard
        var count = defaults.integer(forKey: "cameraEntryCount")
        let hasRated = defaults.bool(forKey: "hasRated")

        count += 1
        defaults.set(count, forKey: "cameraEntryCount")

        let shouldShowRate = !hasRated && (count == 1 || count % 6 == 0)

        if shouldShowRate {
            TabBarRouter.showRateViewController(in: self) {
                self.showCamera()
            }
        } else {
            showCamera()
        }
    }

    private func showCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera is not found.")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false

        self.present(imagePicker, animated: true)
    }

    private func updateTabBarBorderLayer() {
        let width = tabBar.bounds.width
        let height: CGFloat = 0.5
        let buttonWidth: CGFloat = 64
        let gapWidth: CGFloat = buttonWidth

        let path = UIBezierPath()
        let startX = (width - gapWidth) / 2
        let endX = startX + gapWidth

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: startX, y: 0))
        path.move(to: CGPoint(x: endX, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))

        borderLayer.path = path.cgPath
        borderLayer.strokeColor = UIColor(hex: "#8E9DB5")?.cgColor
        borderLayer.lineWidth = height

        if borderLayer.superlayer == nil {
            tabBar.layer.addSublayer(borderLayer)
        }

        borderLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }

    @objc func setPageToFirst() {
        self.selectedIndex = 0
    }

    func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: Preview
import SwiftUI

struct TabBarViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let tabBarViewController = TabBarViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarViewControllerProvider.ContainerView>) -> TabBarViewController {
            return tabBarViewController
        }

        func updateUIViewController(_ uiViewController: TabBarViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<TabBarViewControllerProvider.ContainerView>) {
        }
    }
}
