//
//  SelectViewController.swift
//  PDFConverter
//
//  Created by Er Baghdasaryan on 24.04.25.
//

import UIKit
import PDFConverterViewModel
import SnapKit
import PDFConverterModel

class SelectViewController: BaseViewController {

    var viewModel: ViewModel?
    private let header = UILabel(text: "Select file",
                                 textColor: UIColor.black,
                                 font: UIFont(name: "SFProText-Bold", size: 18))
    var collectionView: UICollectionView!

    private var selectedIndex: IndexPath?
    private var selectedGenre: SavedFilesModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .white

        self.header.textAlignment = .left

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 343, height: 65)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(SelectEmptyCollectionViewCell.self)
        collectionView.register(SelectFileCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.insetsLayoutMarginsFromSafeArea = false

        self.view.addSubview(header)
        self.view.addSubview(collectionView)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
        self.viewModel?.loadFiles()
        self.collectionView.reloadData()
    }

    func setupConstraints() {

        header.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(125)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(20)
        }

        collectionView.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.bottom.equalToSuperview()
        }
    }

}

//MARK: Make buttons actions
extension SelectViewController {
    
    private func makeButtonsAction() {
        
    }

    @objc func plusFile() {
        
    }

    @objc func customBackFunctionality() {
        guard let navigationController = self.navigationController else { return }

        SelectRouter.popViewController(in: navigationController)
    }

    private func setupNavigationItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "plusFileButton"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.addTarget(self, action: #selector(plusFile), for: .touchUpInside)

        let button1 = UIButton(type: .custom)
        button1.setImage(UIImage(named: "ntfBack"), for: .normal)
        button1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button1.addTarget(self, action: #selector(customBackFunctionality), for: .touchUpInside)

        let rightButton = UIBarButtonItem(customView: button)
        let leftButton = UIBarButtonItem(customView: button1)

        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
    }

}

extension SelectViewController: IViewModelableController {
    typealias ViewModel = ISelectViewModel
}

//MARK: Collection view delegate
extension SelectViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.savedFiles.isEmpty ?? true ? 1 : self.viewModel!.savedFiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.viewModel?.savedFiles.isEmpty ?? true {

            self.header.isHidden = true

            let cell: SelectEmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        } else {
            self.header.isHidden = false

            let cell: SelectFileCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

            cell.updateSelectionState(isSelected: indexPath == selectedIndex)

            if let model = self.viewModel?.savedFiles[indexPath.row] {
                cell.configure(model: model)
            }

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndex = selectedIndex,
           let previousCell = collectionView.cellForItem(at: previousIndex) as? SelectFileCollectionViewCell {
            previousCell.updateSelectionState(isSelected: false)
        }

        selectedIndex = indexPath
        selectedGenre = self.viewModel?.savedFiles[indexPath.row]

        if let newCell = collectionView.cellForItem(at: indexPath) as? SelectFileCollectionViewCell {
            newCell.updateSelectionState(isSelected: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.viewModel?.savedFiles.isEmpty ?? true {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: 343, height: 65)
        }
    }
}

//MARK: Preview
import SwiftUI

struct SelectViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let selectViewController = SelectViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<SelectViewControllerProvider.ContainerView>) -> SelectViewController {
            return selectViewController
        }

        func updateUIViewController(_ uiViewController: SelectViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SelectViewControllerProvider.ContainerView>) {
        }
    }
}
