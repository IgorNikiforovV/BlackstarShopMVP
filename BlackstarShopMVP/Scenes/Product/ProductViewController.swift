//
//  ProductViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductDisplayLogic: AnyObject {
    func configureUI(viewModel: Product.ViewModel.UIConfiguration)
    func updateUI(viewModel: Product.ViewModel.UIUpdating)
    func navigateToScene(viewModel: Product.ViewModel.Routing)
}

class ProductViewController: UIViewController, ProductDisplayLogic {

    var interactor: ProductBusinessLogic?
    var router: (NSObjectProtocol & ProductRoutingLogic)?

    // MARK: @IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var noDataLabel: UILabel!

    private var products = [ProductCellInput]()

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Routing

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor?.handleAction(request: .viewIsReady)

        configureCollectionView()
        configureNoDataLabel()
    }

    func configureUI(viewModel: Product.ViewModel.UIConfiguration) {

    }

    func updateUI(viewModel: Product.ViewModel.UIUpdating) {
        switch viewModel {
        case .refreshControlHidding(_):
            print("refreshControlHidding")
        case .collectionViewDataReloading(let productCellItems):
            noDataLabel.isHidden = !productCellItems.isEmpty
            products = productCellItems
            collectionView.reloadData()
        case .collectionViewErrorReloading(_):
            products = []
            collectionView.reloadData()
        }
    }

    func navigateToScene(viewModel: Product.ViewModel.Routing) {

    }

}

// MARK: - UICollectionViewDataSource

extension ProductViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath)
        if let cell = cell as? ProductCell {
            cell.configure(products[indexPath.item])
        }
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let frame = collectionView.frame
        let cellWidth = (frame.width - Const.allCellSpasing) / Const.oneRowCellCount
        return CGSize(width: cellWidth, height: Const.cellHeight)
    }

}

// MARK: Private methods

private extension ProductViewController {

    func configureCollectionView() {
        collectionView.register(
            UINib(nibName: ProductCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: ProductCell.identifier
        )
    }

    func configureNoDataLabel() {
        noDataLabel.isHidden = true
        noDataLabel.attributedText = Const.noDataAttributedText()
    }

}

private extension ProductViewController {

    enum Const {

        // cell
        static let cellHeight: CGFloat = 260
        static var allCellSpasing: CGFloat {
            leftCellSpasing + betweenCellsSpacing + rightCellSpasing
        }
        static let rightCellSpasing: CGFloat = 16
        static let leftCellSpasing: CGFloat = 16
        static let betweenCellsSpacing: CGFloat = 8
        static let oneRowCellCount: CGFloat = 2

        // no data label
        static func noDataAttributedText() -> NSAttributedString {
            NSAttributedString(string: noDataTitle, attributes: titleAttributes)
        }
        static let noDataTitle = R.string.localizable.productNoDataTitle()
        static let titleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: R.color.colors.blackColor()!,
            NSAttributedString.Key.font: R.font.sfProDisplayMedium(size: 13)!,
            NSAttributedString.Key.kern: 0.19
        ]

    }

}
