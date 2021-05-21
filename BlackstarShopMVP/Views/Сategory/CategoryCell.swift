//
//  CategoryCell.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//

import UIKit

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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

// MARK: Public methods

extension CategoryCell {

    func configure(_ viewModel: CategoryCellVModel) {
        titleLabel.attributedText = viewModel.title
        pictureImageView.load(url: viewModel.picture)
        iconImageView.load(url: viewModel.icon)
    }

}

// MARK: Private methods

private extension CategoryCell {

    func configureSeparatorView() {
        separatorView.backgroundColor = Const.separatorBackgroundColor
    }

    func configureRoundedView() {
        roundedView.layer.cornerRadius = max(roundedView.frame.width, roundedView.frame.height) / 2
        roundedView.backgroundColor = Const.separatorBackgroundColor
        //roundedView.layer.borderWidth = 1
    }

}

private extension CategoryCell {

    enum Const {

        static let separatorBackgroundColor = R.color.colors.separatorColor()

    }

}
