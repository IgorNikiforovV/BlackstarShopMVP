//
//  ProductListSceneViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductListSceneDisplayLogic: AnyObject {
    func configureUI(viewModel: ProductListSceneModels.ViewModel.UIConfiguration)
    func updateUI(viewModel: ProductListSceneModels.ViewModel.UIUpdating)
    func navigateToScene(viewModel: ProductListSceneModels.ViewModel.Routing)
}

class ProductListSceneViewController: UIViewController, ProductListSceneDisplayLogic {

    var interactor: ProductListSceneBusinessLogic?
    var router: (NSObjectProtocol & ProductListSceneRoutingLogic)?

    // MARK: @IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var noDataLabel: UILabel!

    private var products: [ProductCellInput]?

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

    func configureUI(viewModel: ProductListSceneModels.ViewModel.UIConfiguration) {

    }

    func updateUI(viewModel: ProductListSceneModels.ViewModel.UIUpdating) {
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

    func navigateToScene(viewModel: ProductListSceneModels.ViewModel.Routing) {
        switch viewModel {
        case .productScene(let product):
            router?.showProductScene(product: product)
        }
    }

}

// MARK: - UICollectionViewDataSource

extension ProductListSceneViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let products = products else { return 6 }

        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath)
        if let products = products,
           let cell = cell as? ProductCell {
            cell.configure(products[indexPath.item])
        }
        return cell
    }

}

// MARK: - UITableViewDelegate

extension ProductListSceneViewController: UITableViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor?.handleAction(request: .cellTapped(indexPath.item))
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductListSceneViewController: UICollectionViewDelegateFlowLayout {

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

private extension ProductListSceneViewController {

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

private extension ProductListSceneViewController {

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
