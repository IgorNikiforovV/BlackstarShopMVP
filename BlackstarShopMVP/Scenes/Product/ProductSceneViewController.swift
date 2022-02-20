//
//  ProductSceneViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 30.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductSceneDisplayLogic: AnyObject {
    func updateImageSlider(with viewModel: ProductScene.StartupData.ViewModel)
    func updateProductName(with viewModel: ProductScene.StartupData.ViewModel)
    func updateProductDescription(with viewModel: ProductScene.StartupData.ViewModel)
    func updateProductPrice(with viewModel: ProductScene.StartupData.ViewModel)
    func showSizesSheet(with viewModel: ProductScene.AddBasketTrapping.ViewModel)
}

class ProductSceneViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet private weak var sliderView: ImageHorizontalCollectionView!
    @IBOutlet private weak var contentContainerStackView: UIStackView!
    @IBOutlet private weak var imagesContainerView: UIView!
    @IBOutlet private weak var priceContainerStackView: UIStackView!

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var priceTitleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var addBasketButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!

    var interactor: ProductSceneBusinessLogic?
    var router: (NSObjectProtocol & ProductSceneRoutingLogic)?

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

        interactor?.viewIsReady(request: ProductScene.StartupData.Request())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
    }

}

extension ProductSceneViewController: ProductSceneDisplayLogic {
    func updateImageSlider(with response: ProductScene.StartupData.ViewModel) {
        sliderView.configure(response.imageStringUrls)
    }

    func updateProductName(with response: ProductScene.StartupData.ViewModel) {
        nameLabel.attributedText = Const.nameAttributedText(response.productName)
    }

    func updateProductPrice(with response: ProductScene.StartupData.ViewModel) {
        priceLabel.alpha = 0.5
        priceLabel.attributedText = Const.priceAttributedText(response.price)
    }

    func updateProductDescription(with response: ProductScene.StartupData.ViewModel) {
        guard let description = response.description else { descriptionLabel.isHidden = true; return }
        descriptionLabel.attributedText = description.fromHTML(attributes: [:],
                                                               commonAttribute: Const.descriptionAttributes)
    }

    func showSizesSheet(with viewModel: ProductScene.AddBasketTrapping.ViewModel) {
        let sheetInfo = ShadowSheetInfo(headerText: Const.sizeSheetTitleAttributed,
                                        checkImage: Const.checkMark,
                                        actions: viewModel.sheetActions)
        router?.showSheetController(sheetInfo: sheetInfo)
    }
}

// MARK: private methods

private extension ProductSceneViewController {
    func makeInitialSettings() {
        configureSeparator()
        configurePriceTitle()
        configureAddBasket()
        configureContentContainerStackViewSpacing()
    }

    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }

    func configureSeparator() {
        separatorView.backgroundColor = Const.separatorViewCoor
    }

    func configurePriceTitle() {
        priceTitleLabel.attributedText = Const.priceTitleAttributedText
    }

    func configureContentContainerStackViewSpacing() {
        contentContainerStackView.setCustomSpacing(0, after: nameLabel)
        contentContainerStackView.setCustomSpacing(20, after: priceContainerStackView)
        contentContainerStackView.setCustomSpacing(28, after: addBasketButton)
    }

    func configureAddBasket() {
        addBasketButton.layer.cornerRadius = Const.addBasketCornerRadius
        addBasketButton.backgroundColor = Const.addBasketBackground
        addBasketButton.setAttributedTitle(Const.addBasketTitleAttributedText, for: .normal)
    }

    @IBAction func addBascketButtonTapped(_ sender: UIButton) {
        interactor?.addBasketTapped(request: ProductScene.AddBasketTrapping.Request(sheetRowAttributtes: Const.sheetItemAttributes))
    }

    func showAlert() {

    }
}

// MARK: Constants

private extension ProductSceneViewController {

    enum Const {

        // name label
        static func nameAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: nameAttributes)
        }

        static let nameAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.blackColor()!,
            .font: R.font.sfProDisplayBold(size: 36)!,
            .paragraphStyle: nameParagraphStyle
        ]

        static let nameParagraphStyle: NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.93
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byTruncatingTail
            return paragraphStyle
        }()

        // separator view
        static let separatorViewCoor = R.color.colors.separatorLineColor()!

        // price title label
        static var priceTitleAttributedText: NSAttributedString {
            let priceTitle = R.string.localizable.productPriceTitle()
            return .init(string: priceTitle, attributes: priceTitleAttributes)
        }

        static let priceTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.blackColor()!,
            .font: R.font.sfProTextRegular(size: 18)!,
            .paragraphStyle: priceTitleParagraphStyle
        ]

        static let priceTitleParagraphStyle: NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1
            paragraphStyle.alignment = .left
            paragraphStyle.lineBreakMode = .byTruncatingTail
            return paragraphStyle
        }()

        // price label
        static func priceAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: priceAttributes)
        }

        static let priceAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.blackColor()!,
            .font: R.font.sfProDisplayBold(size: 20)!,
            .paragraphStyle: priceParagraphStyle
        ]

        static let priceParagraphStyle: NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.95
            paragraphStyle.alignment = .right
            paragraphStyle.lineBreakMode = .byTruncatingTail
            return paragraphStyle
        }()

        // addBasket button
        static let addBasketBackground = R.color.colors.blueColor()!
        static let addBasketCornerRadius: CGFloat = 10
        static let addBasketTtile = R.string.localizable.productAddBasketTitle()
        static let addBasketTitleAttributedText = NSAttributedString(string: addBasketTtile, attributes: addBasketAttributes)
        static let addBasketAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.whiteColor()!,
            .font: R.font.sfProDisplayMedium(size: 16)!
        ]

        // description label
        static func descriptionAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: descriptionAttributes)
        }

        static let descriptionAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.blackColor()!,
            .font: R.font.sfProTextRegular(size: 16)!,
            .paragraphStyle: descriptionParagraphStyle,
            .kern: -0.27
        ]

        static let descriptionParagraphStyle: NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.07
            paragraphStyle.alignment = .left
            paragraphStyle.lineBreakMode = .byTruncatingTail
            return paragraphStyle
        }()

        static let checkMark = R.image.common.checkMark()
        static let sizeSheetTitleAttributed = NSAttributedString(string: Const.sizeSheetTitle,
                                                                 attributes: Const.sheetHeaderAttributes)
        static let sizeSheetTitle = R.string.localizable.productAlertSizeTitle()

        static let sheetHeaderAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: R.font.sfProTextSemibold(size: 14)!,
            NSAttributedString.Key.foregroundColor: R.color.colors.blackColor()!
        ]

        static let sheetItemAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: R.font.sfProTextSemibold(size: 13)!,
            NSAttributedString.Key.foregroundColor: R.color.colors.blackColor()!
        ]

    }

}
