//
//  CategoryCell.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//

import UIKit

protocol CategoryCellInput {
    var id: Int { get }
    var picture: URL? { get }
    var title: NSAttributedString { get }
    var icon: URL? { get }
}

class CategoryCell: UITableViewCell {

    // MARK: Properties

    static let identifier = "CategoryCell"

    // MARK: @IBOutlet

    @IBOutlet private weak var pictureImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var roundedView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        configureSeparatorView()
        configureRoundedView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pictureImageView.image = nil
        iconImageView.image = nil
        titleLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

// MARK: Public methods

extension CategoryCell {

    func configure(_ viewModel: CategoryCellInput) {
        titleLabel.attributedText = viewModel.title
        pictureImageView.load(
            url: viewModel.picture,
            placeholder: Const.imagePlaceholder,
            needMakeSquare: true
        )
        iconImageView.load(url: viewModel.icon, placeholder: nil)
    }

}

// MARK: Private methods

private extension CategoryCell {

    func configureSeparatorView() {
        separatorView.backgroundColor = Const.separatorBackgroundColor
    }

    func configureRoundedView() {
        roundedView.layer.cornerRadius = max(roundedView.frame.width, roundedView.frame.height) / 2
        roundedView.backgroundColor = Const.imageBackgroundColor
    }

}

private extension CategoryCell {

    enum Const {

        static let separatorBackgroundColor = R.color.colors.separatorColor()
        static let imageBackgroundColor = R.color.colors.lightGreyColor()
        static let imagePlaceholder = R.image.categoryCell.placeholder()

    }

}
