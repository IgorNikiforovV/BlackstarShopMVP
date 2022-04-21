//
//  BasketCell.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 05.04.2022.
//

import UIKit

protocol BasketCellInput {
    var imageUrl: URL? { get }
    var name: String { get }
    var size: String? { get }
    var color: String { get }
    var price: String { get }
}

class BasketCell: UITableViewCell {

    // MARK: @IBOutlet

    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    @IBOutlet private weak var colorLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var deleteImageView: UIImageView!

    // MARK: Properties

    static let identifier = "BasketCell"

    override func awakeFromNib() {
        super.awakeFromNib()

    }

}

// MARK: - Public methods

extension BasketCell {

    func configure(_ viewModel: BasketCellInput) {
        mainImageView.load(url: viewModel.imageUrl, placeholder: UIImage())
        nameLabel.attributedText = Const.nameAttributedText(viewModel.name)
        sizeLabel.attributedText = Const.sizeAttributedText(viewModel.size ?? "не задан")
        colorLabel.attributedText = Const.colorAttributedText(viewModel.color)
        priceLabel.attributedText = Const.priceAttributedText(viewModel.price)
        deleteImageView.image = Const.basketImage
    }

}

private extension BasketCell {

    enum Const {

        // nameLabel
        static func nameAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: nameAttributes)
        }

        static let nameAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.blueColor()!,
            .font: R.font.sfProDisplayMedium(size: 16)!,
            .paragraphStyle: nameParagraphStyle
        ]

        static let nameParagraphStyle: NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            paragraphStyle.lineBreakMode = .byTruncatingTail
            return paragraphStyle
        }()

        // sizeLabel
        static func sizeAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: sizeAttributes)
        }

        static let sizeAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.separatorColor()!,
            .font: R.font.sfProDisplayMedium(size: 11)!,
            .paragraphStyle: sizeParagraphStyle
        ]

        static let sizeParagraphStyle: NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            paragraphStyle.lineBreakMode = .byTruncatingTail
            return paragraphStyle
        }()

        // colorLabel
        static func colorAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: colorAttributes)
        }

        static let colorAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.separatorColor()!,
            .font: R.font.sfProDisplayMedium(size: 11)!,
            .paragraphStyle: colorParagraphStyle
        ]

        static let colorParagraphStyle: NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            paragraphStyle.lineBreakMode = .byTruncatingTail
            return paragraphStyle
        }()

        // priceLabel
        static func priceAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: priceAttributes)
        }

        static let priceAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.separatorColor()!,
            .font: R.font.sfProDisplayMedium(size: 11)!,
            .paragraphStyle: priceParagraphStyle
        ]

        static let priceParagraphStyle: NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            paragraphStyle.lineBreakMode = .byTruncatingTail
            return paragraphStyle
        }()

        static let basketImage = R.image.basket.basketIcon()

    }

}
