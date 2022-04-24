//
//  BasketSceneViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 05.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Rswift

protocol BasketSceneDisplayLogic: AnyObject {
    func showInitialBasketProducts(with viewModel: BasketScene.StartupData.ViewModel)
    func showChangedBasketProducts(with viewModel: BasketScene.StorageChange.ViewModel)
}

class BasketSceneViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalTitleLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var placeOrderButton: UIButton!

    private var deleteAllItemsButton = UIButton()

    // MARK: - Properties

    var interactor: BasketSceneBusinessLogic?
    var router: (NSObjectProtocol & BasketSceneRoutingLogic)?

    private var basketCellViewModels = [BasketCellInput]() {
        didSet {
            deleteAllItemsButton.isHidden = basketCellViewModels.isEmpty
        }
    }

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

        makeInitialSettings()
        interactor?.viewIsReady(request: BasketScene.StartupData.Request())
    }

}

// MARK: BasketSceneDisplayLogic

extension BasketSceneViewController: BasketSceneDisplayLogic {

    func showInitialBasketProducts(with viewModel: BasketScene.StartupData.ViewModel) {
        configureTotalPrice(price: viewModel.totalPrice)
        basketCellViewModels = viewModel.basketCells
        tableView.reloadData()
    }

    func showChangedBasketProducts(with viewModel: BasketScene.StorageChange.ViewModel) {
        basketCellViewModels = viewModel.basketCells

        configureTotalPrice(price: viewModel.totalPrice)

        let deleteIndexPaths = viewModel.deletedItemsIndexes
            .map { IndexPath(item: $0, section: 0) }
        if !deleteIndexPaths.isEmpty {
            tableView.deleteRows(at: deleteIndexPaths, with: .middle)
        }


        let insertIndexPaths = viewModel.insertedItemsIndexes
            .filter { basketCellViewModels.indices.contains($0) }
            .map { IndexPath(item: $0, section: 0) }
        if !insertIndexPaths.isEmpty {
            tableView.insertRows(at: insertIndexPaths, with: .middle)
        }
    }

}

// MARK: private methods

private extension BasketSceneViewController {

    func makeInitialSettings() {
        interactor?.setNotificationStorageSubscribing(request: BasketScene.StorageSubscribing.Request(subscriber: self))

        configureDeleteAllItems()
        configureTableView()
        configureTotalTitle()
        configureSeparator()
        configureSeparator()
        configurePlaceOrderTitle()
    }

    func configureDeleteAllItems() {
        deleteAllItemsButton.setImage(Const.allDeleteButton, for: .normal)
        deleteAllItemsButton.addTarget(self, action: #selector(allBasketButtonDidTap), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: deleteAllItemsButton)
    }

    func configureTableView() {
        tableView.register(R.nib.basketCell)
    }

    func configureTotalTitle() {
        totalTitleLabel.attributedText = Const.totalTitleAttributedText
    }

    func configureTotalPrice(price: String) {
        totalPriceLabel.attributedText = Const.totalPriceAttributedText(price)
        totalPriceLabel.alpha = 0.6
    }

    func configureSeparator() {
        separatorView.backgroundColor = Const.separatorViewCoor
    }

    func configurePlaceOrderTitle() {
        placeOrderButton.layer.cornerRadius = Const.placeOrderCornerRadius
        placeOrderButton.backgroundColor = Const.placeOrderBackground
        placeOrderButton.setAttributedTitle(Const.placeOrderAttributedText(isBasketEmpty: false), for: .normal)
    }

}

// MARK: BasketItemsSubscribable

extension BasketSceneViewController: BasketItemsSubscribable {

    func basketItemsDidChange(basketItemsChange: DomainDatabaseChange<BasketItem>) {
        interactor?.storageWasChanged(request: BasketScene.StorageChange.Request(basketItemsChange: basketItemsChange))
    }

}

// MARK: UITableViewDataSource

extension BasketSceneViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        basketCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.basketCell, for: indexPath)!
        if let basketCell = basketCellViewModels[safeIndex: indexPath.item] {
            cell.configure(basketCell)
            cell.delegate = self
        }
        return cell
    }

}

// MARK: BasketCellDelegate

extension BasketSceneViewController: BasketCellDelegate {

    func basketItemDeleteButtonDidTap(_ cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let request = BasketScene.BasketItemDeleting.Request(index: indexPath.item)
            interactor?.deleteBasketItemButtonDidTap(request: request)
        }
    }

}

// MARK: private methods

private extension BasketSceneViewController {

    @objc func allBasketButtonDidTap() {
        interactor?.deleteAllBasketItemsButtonDidTap(request: BasketScene.AllBasketItemsDeleting.Request())
    }

}

// MARK: Constants

private extension BasketSceneViewController {

    enum Const {

        // all Delete Button
        static let allDeleteButton = R.image.basket.deleteAll()!

        // total title label
        static var totalTitleAttributedText: NSAttributedString {
            let priceTitle = R.string.localizable.basketTotalTitle()
            return .init(string: priceTitle, attributes: totalTitleAttributes)
        }

        static let totalTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.blackColor()!,
            .font: R.font.sfProDisplayMedium(size: 16)!
        ]

        // total price label
        static func totalPriceAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: totalPriceAttributes)
        }

        static let totalPriceAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.blackColor()!,
            .font: R.font.sfProTextSemibold(size: 16)!
        ]

        // separator view
        static let separatorViewCoor = R.color.colors.separatorLineColor()!

        // place order button
        static let placeOrderBackground = R.color.colors.blueColor()!
        static let placeOrderCornerRadius: CGFloat = 24
        static let placeOrderTtile = R.string.localizable.basketPlaceOrderTitle()
        static let placeOrderTtileEmpty = R.string.localizable.basketPlaceOrderTitleEmpty()

        static func placeOrderAttributedText(isBasketEmpty: Bool) -> NSAttributedString {
            let title = isBasketEmpty ? placeOrderTtileEmpty : placeOrderTtile
            return NSAttributedString(string: title, attributes: placeOrderAttributes)
        }
        static let placeOrderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.whiteColor()!,
            .font: R.font.sfProDisplayMedium(size: 15)!
        ]

    }

}
