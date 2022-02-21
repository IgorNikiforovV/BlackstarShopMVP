//
//  BackButtonView.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 21.02.2022.
//

import UIKit

protocol BackButtonViewDelegate: AnyObject {
    func backButtonDidTap()
}

class BackButtonView: UIView {

    private var backButtonImage: UIImageView {
        let image = UIImageView(image: R.image.product.backButton()!)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }

    weak var delegate: BackButtonViewDelegate?

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension BackButtonView {

    func initialize() {
        covereSuperview(subview: backButtonImage)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:)))
        addGestureRecognizer(tapGestureRecognizer)

        layer.borderWidth = 1
        layer.borderColor = R.color.colors.turquoiseColor()?.cgColor
    }

    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        delegate?.backButtonDidTap()
    }

}
