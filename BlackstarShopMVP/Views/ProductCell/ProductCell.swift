//
//  ProductCell.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//

import UIKit
import SkeletonView

protocol ProductCellInput {
    var title: String { get }
    var description: String? { get }
    var picture: String? { get }
    var price: String { get }
}

class ProductCell: UICollectionViewCell {

    // MARK: @IBOutlet

    @IBOutlet private weak var contentContainerView: UIView!
    @IBOutlet private weak var skeletonContainerView: UIView!

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var buyButton: UIButton!

    // MARK: Properties

    static let identifier = "ProductCell"
    private let gradient = SkeletonGradient(baseColor: UIColor.concrete)

    // MARK: - Object lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        initialize()
        showLoading()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        showLoading()
    }

}

// MARK: - Public methods

extension ProductCell {

    func configure(_ viewModel: ProductCellInput) {
        titleLabel.attributedText = NSAttributedString(
            string: viewModel.title,
            attributes: Const.titleAttributes
        )
        if let description = viewModel.description {
            descriptionLabel.attributedText = NSAttributedString(
                string: description,
                attributes: Const.descriptionAttributes
            )
        } else {
            descriptionLabel.isHidden = true
        }

        if let imageURLText = viewModel.picture,
        let url = Const.url(from: imageURLText) {
            imageView.load(url: url, placeholder: Const.imagePlaceholder, needMakeSquare: true)
        }

        priceLabel.attributedText = Const.priceAttributedText(viewModel.price)

        hideLoading()
    }

}

private extension ProductCell {

    func initialize() {
        configureContentView()
        configureBuyButton()
        configureSkeletonViews()
    }

    func configureContentView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.6
        contentView.layer.borderColor = Const.borderColor.cgColor
    }

    func configureBuyButton() {
        buyButton.backgroundColor = Const.buyBackgroundColor
        buyButton.layer.cornerRadius = 5
        buyButton.setAttributedTitle(
            .init(string: Const.buyTitle, attributes: Const.buyTitleAttributes
        ), for: .normal)
    }

    func configureSkeletonViews() {
        skeletonContainerView.layer.cornerRadius = 8
        skeletonContainerView.layer.borderWidth = 0.6
        skeletonContainerView.layer.borderColor = Const.borderColor.cgColor

        skeletonContainerView.subviews.forEach {
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
        }
    }

    func showLoading() {
        isUserInteractionEnabled = false

        contentContainerView.isHidden = true

        DispatchQueue.main.async {
            self.skeletonContainerView.subviews.forEach {
                $0.showAnimatedGradientSkeleton(usingGradient: self.gradient)
                $0.showGradientSkeleton()
            }
        }
        skeletonContainerView.isHidden = false
    }

    func hideLoading() {
        isUserInteractionEnabled = true

        skeletonContainerView.isHidden = true
        DispatchQueue.main.async {
            self.skeletonContainerView.subviews.forEach {
                $0.hideSkeleton()
            }
        }

        contentContainerView.isHidden = false
    }

}

private extension ProductCell {

    enum Const {

        // content view
        static let borderColor = R.color.colors.separatorColor()!

        // buyButton
        static let buyTitle = R.string.localizable.productCellPayTitle()
        static let buyBackgroundColor = R.color.colors.pinkColor()!
        static let buyTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.whiteColor()!,
            .font: R.font.sfProDisplayMedium(size: 8)!
        ]

        static let imageBackgroundColor = R.color.colors.lightGreyColor()
        static let imagePlaceholder = R.image.categoryCell.placeholder()

        // title
        static let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.blackColor()!,
            .font: R.font.sfProDisplayMedium(size: 16)!,
            .kern: 0.19
        ]

        // description
        static let descriptionAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.grayColor()!,
            .font: R.font.sfProDisplayMedium(size: 11)!,
            .kern: 0.19
        ]

        // price
        static func priceAttributedText(_ text: String) -> NSAttributedString {
            let price = R.string.localizable.productCellPriceTitle(text)
            return .init(string: price, attributes: priceAttributes)
        }

        static let priceAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.blackColor()!,
            .font: R.font.sfProDisplayMedium(size: 16)!,
            .kern: 0.19
        ]

        static func url(from text: String?) -> URL? {
            guard let text = text else { return nil }
            let urlText = "\(NetworkConst.baseUrl)\(text)"
            return URL(string: urlText)
        }

    }

}
