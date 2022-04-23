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
    func showBasketProducts(with viewModel: BasketScene.StartupData.ViewModel)
}

class BasketSceneViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalTitleLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var placeOrderButton: UIButton!

    // MARK: - Properties

    var interactor: BasketSceneBusinessLogic?
    var router: (NSObjectProtocol & BasketSceneRoutingLogic)?

    private var basketCells = [BasketCellInput]()

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

extension BasketSceneViewController: BasketSceneDisplayLogic {

    func showBasketProducts(with viewModel: BasketScene.StartupData.ViewModel) {
        configureTotalPrice(price: viewModel.totalPrice)
        basketCells = viewModel.basketCells
        tableView.reloadData()
    }

}

// MARK: private methods

private extension BasketSceneViewController {

    func makeInitialSettings() {
        interactor?.setNotificationStorageSubscribing(request: BasketScene.StorageSubscribing.Request(subscriber: self))

        configureTableView()
        configureTotalTitle()
        configureSeparator()
        configureSeparator()
        configurePlaceOrderTitle()
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

    func basketItemsDidChange(newBasketItems: [BasketItem]) {
        interactor?.storageWasChanged(request: BasketScene.StorageChange.Request(newBasketItems: newBasketItems))
    }

}

// MARK: UITableViewDataSource

extension BasketSceneViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        basketCells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.basketCell, for: indexPath)!
        if let basketCell = basketCells[safeIndex: indexPath.item] {
            cell.configure(basketCell)
        }
        return cell
    }

}

// MARK: UITableViewDelegate

//extension BasketSceneViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
//
//}


// MARK: Constants

private extension BasketSceneViewController {

    enum Const {

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
