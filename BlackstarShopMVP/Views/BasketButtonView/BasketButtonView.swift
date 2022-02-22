//
//  BasketButtonView.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.02.2022.
//

import UIKit

protocol BasketButtonViewDelegate: AnyObject {
    func backButtonDidTap()
}

class BasketButtonView: UIView {

    private let numberLabel = UILabel()
    private let raundedView = UIView()

    private var backButtonImage: UIImageView {
        let image = UIImageView(image: R.image.product.basket()!)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }

    weak var delegate: BasketButtonViewDelegate?

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BasketButtonView {

    func updateNumber(with num: Int) {
        if num > 0 {
            raundedView.isHidden = false
            numberLabel.text = "\(num)"
        } else {
            raundedView.isHidden = true
            numberLabel.text = " "
        }
    }

//    func fitNumberLabelIntoRaundedView(with text: String) {
//        numberLabel
//    }

}

// MARK: Private methods

private extension BasketButtonView {

    func initialize() {
        covereSuperview(subview: backButtonImage)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:)))
        addGestureRecognizer(tapGestureRecognizer)

        layer.borderWidth = 1
        layer.borderColor = R.color.colors.turquoiseColor()?.cgColor

        configureNumberLabel()
        configureRaundedView()
    }

    func configureRaundedView() {
        raundedView.backgroundColor = Const.roundedBackgroundColor
        raundedView.translatesAutoresizingMaskIntoConstraints = false
        raundedView.widthAnchor.constraint(equalTo: raundedView.heightAnchor).isActive = true

        addSubview(raundedView)
        numberLabel.centerXAnchor.constraint(equalTo: raundedView.centerXAnchor).isActive = true
        numberLabel.centerYAnchor.constraint(equalTo: raundedView.centerYAnchor).isActive = true
    }

    func configureNumberLabel() {
        numberLabel.numberOfLines = 1
        numberLabel.attributedText = Const.nameAttributedText("111")
        numberLabel.translatesAutoresizingMaskIntoConstraints = false

        raundedView.addSubview(numberLabel)
        numberLabel.leftAnchor.constraint(equalTo: raundedView.leftAnchor).isActive = true
        numberLabel.rightAnchor.constraint(equalTo: raundedView.rightAnchor).isActive = true
    }

    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        delegate?.backButtonDidTap()
    }

}

// MARK: Const

private extension BasketButtonView {

    enum Const {

        // rounded view
        static let roundedBackgroundColor = R.color.colors.scarletColor()!

        // number label
        static func nameAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: nameAttributes)
        }

        static let nameAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.whiteColor()!,
            .font: R.font.sfProTextRegular(size: 12)!
        ]
    }

}
