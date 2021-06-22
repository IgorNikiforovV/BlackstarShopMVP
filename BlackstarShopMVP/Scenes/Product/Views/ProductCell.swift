//
//  ProductCell.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//

import UIKit

protocol ProductCellInput {
    var id: Int { get }
    var title: String { get }
    var description: String { get }
    var picture: URL? { get }
    var price: String { get }
}

class ProductCell: UICollectionViewCell {

    // MARK: @IBOutlet

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var buyButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    func configure(viewModel: ProductCellInput) {
        titleLabel.attributedText = NSAttributedString(
            string: viewModel.title,
            attributes: Const.titleAttributes
        )
        descriptionLabel.attributedText = NSAttributedString(
            string: viewModel.description,
            attributes: Const.descriptionAttributes
        )

        imageView.load(
            url: viewModel.picture,
            placeholder: Const.imagePlaceholder,
            needMakeSquare: true
        )
        priceLabel.attributedText = NSAttributedString(
            string: viewModel.price,
            attributes: Const.priceAttributes
        )
    }

}

private extension ProductCell {

    func initialize() {
        configureBuyButton()
    }

    func configureBuyButton() {
        buyButton.backgroundColor = Const.buyBackgroundColor
        buyButton.layer.cornerRadius = 5
        buyButton.setAttributedTitle(
            NSAttributedString(string: Const.buyTitle, attributes: Const.buyTitleAttributes
        ), for: .normal)
    }

}

private extension ProductCell {

    enum Const {

        // buyButton
        static let buyTitle = R.string.localizable.productCellBayButtonTitle()
        static let buyBackgroundColor = R.color.colors.pinkColor()!
        static let buyTitleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: R.color.colors.whiteColor()!,
            NSAttributedString.Key.font: R.font.sfProDisplayMedium(size: 8)!
        ]

        static let imageBackgroundColor = R.color.colors.lightGreyColor()
        static let imagePlaceholder = R.image.categoryCell.placeholder()

        // title
        static let titleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: R.color.colors.blackColor()!,
            NSAttributedString.Key.font: R.font.sfProDisplayMedium(size: 16)!,
            NSAttributedString.Key.kern: 0.19
        ]

        // description
        static let descriptionAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: R.color.colors.grayColor()!,
            NSAttributedString.Key.font: R.font.sfProDisplayMedium(size: 11)!,
            NSAttributedString.Key.kern: 0.19
        ]

        // price
        static let priceAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: R.color.colors.blackColor()!,
            NSAttributedString.Key.font: R.font.sfProDisplayMedium(size: 16)!,
            NSAttributedString.Key.kern: 0.19
        ]

    }

}
