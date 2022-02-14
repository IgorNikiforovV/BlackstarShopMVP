//
//  ProductSceneViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 30.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductSceneDisplayLogic: AnyObject {
    func updateImageSlider(response: ProductScene.StartupData.ViewModel)
    func updateProductName(response: ProductScene.StartupData.ViewModel)
    func updateProductDescription(response: ProductScene.StartupData.ViewModel)
    func updateProductPrice(response: ProductScene.StartupData.ViewModel)
}

class ProductSceneViewController: UIViewController {

    @IBOutlet private weak var sliderView: ImageHorizontalCollectionView!
    @IBOutlet private weak var contentContainerStackView: UIStackView!
    @IBOutlet private weak var imagesContainerView: UIView!

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

        interactor?.viewIsReady(request: ProductScene.StartupData.Request())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }

}

extension ProductSceneViewController {
    func setNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
}

extension ProductSceneViewController: ProductSceneDisplayLogic {
    func updateImageSlider(response: ProductScene.StartupData.ViewModel) {
        sliderView.configure(response.imageStringUrls)
    }

    func updateProductName(response: ProductScene.StartupData.ViewModel) {
        nameLabel.attributedText = Const.nameAttributedText(response.productName)
    }

    func updateProductDescription(response: ProductScene.StartupData.ViewModel) {

    }

    func updateProductPrice(response: ProductScene.StartupData.ViewModel) {

    }
}

// MARK: Constants

private extension ProductSceneViewController {

    enum Const {

        static func nameAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: nameAttributes)
        }

        static let nameAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.blackColor()!,
            .font: R.font.sfProDisplayBold(size: 36)!,
            .paragraphStyle: nameParagraphStyle
        ]

        static var nameParagraphStyle: NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.93
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byTruncatingTail
            return paragraphStyle
        }()

    }

}
