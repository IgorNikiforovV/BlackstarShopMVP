//
//  BasketSceneViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 05.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol BasketSceneDisplayLogic: AnyObject {
    func displayData(viewModel: BasketScene.Model.ViewModel.ViewModelData)
}

class BasketSceneViewController: UIViewController, BasketSceneDisplayLogic {

    // MARK: - IBOutlets

    @IBOutlet private weak var totalTitleLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var placeOrderButton: UIButton!

    // MARK: - Properties

    var interactor: BasketSceneBusinessLogic?
    var router: (NSObjectProtocol & BasketSceneRoutingLogic)?

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
    }

    func displayData(viewModel: BasketScene.Model.ViewModel.ViewModelData) {

    }

}

// MARK: private methods

private extension BasketSceneViewController {

    func makeInitialSettings() {
        configureTotalTitle()
        configureTotalPrice()
        configureSeparator()
        configureSeparator()
        placeOrderTitle()
    }

    func configureTotalTitle() {
        totalTitleLabel.attributedText = Const.totalTitleAttributedText
    }

    func configureTotalPrice() {
        totalPriceLabel.attributedText = Const.totalPriceAttributedText("2 500Р")
        totalPriceLabel.alpha = 0.4
    }

    func configureSeparator() {
        separatorView.backgroundColor = Const.separatorViewCoor
    }

    func placeOrderTitle() {
        placeOrderButton.layer.cornerRadius = Const.placeOrderCornerRadius
        placeOrderButton.backgroundColor = Const.placeOrderBackground
        placeOrderButton.setAttributedTitle(Const.placeOrderAttributedText(isBasketEmpty: false), for: .normal)
    }

}

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
