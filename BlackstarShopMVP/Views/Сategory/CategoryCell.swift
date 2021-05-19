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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

// MARK: Public methods

extension CategoryCell {

    func configure(_ viewModel: CategoryCellVModel) {

    }

}
