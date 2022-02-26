//
//  ImageHorizontalCollectionCell.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 06.02.2022.
//

import UIKit

class ImageHorizontalCollectionCell: UICollectionViewCell {

    // MARK: Outlets

    @IBOutlet private weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

// MARK: - Public methods

extension ImageHorizontalCollectionCell {

    func configure(_ image: UIImage) {
        imageView.image = image
    }

}
