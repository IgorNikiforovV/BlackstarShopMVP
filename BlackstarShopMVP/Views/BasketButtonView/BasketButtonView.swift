//
//  BasketButtonView.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.02.2022.
//

import UIKit

protocol BasketButtonViewDelegate: AnyObject {
    func basketButtonDidTap()
}

class BasketButtonView: UIView {

    // MARK: - Properties

    private let badgeLabel = UILabel()
    private let basketButtonImage = UIImageView()
    private var widthBasketButtonImageConstraint: NSLayoutConstraint?

    weak var delegate: BasketButtonViewDelegate?

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 30.5, height: 30.5))
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public methods

extension BasketButtonView {

    func updateBadge(with number: String) {
        if let num = Int(number), num > 0 {
            badgeLabel.isHidden = false
            badgeLabel.attributedText = Const.badgeAttributedText(number)
            setVisibleBorders(showBigBorder: true)
        } else {
            badgeLabel.isHidden = true
            badgeLabel.attributedText = Const.badgeAttributedText("")
            setVisibleBorders(showBigBorder: false)
        }
        setBadgeLabelFrame()
    }

}

// MARK: Private methods

private extension BasketButtonView {

    func initialize() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:)))
        addGestureRecognizer(tapGestureRecognizer)

        layer.borderColor = R.color.colors.turquoiseColor()?.cgColor

        configureBasketButtonImage()
        configureBadgeLabel()
    }

    func configureBasketButtonImage() {
        basketButtonImage.image = R.image.product.basket()!
        basketButtonImage.contentMode = .scaleAspectFit
        basketButtonImage.layer.borderColor = R.color.colors.turquoiseColor()?.cgColor
        basketButtonImage.layer.borderWidth = 1

        basketButtonImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(basketButtonImage)
        let badgeHeightHalf = CGFloat(Const.badgeHeight / 2)
        NSLayoutConstraint.activate([
            basketButtonImage.topAnchor.constraint(equalTo: topAnchor, constant: badgeHeightHalf),
            basketButtonImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: badgeHeightHalf),
            basketButtonImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -badgeHeightHalf),
            basketButtonImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -badgeHeightHalf)
        ])
    }

    func configureBadgeLabel() {
        badgeLabel.layer.borderColor = UIColor.white.cgColor
        badgeLabel.layer.borderWidth = 1
        badgeLabel.layer.masksToBounds = true
        badgeLabel.layer.cornerRadius = badgeLabel.bounds.size.height / 2
        badgeLabel.backgroundColor = Const.badgeBackgroundColor

        badgeLabel.isHidden = true

        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(badgeLabel)
        widthBasketButtonImageConstraint = badgeLabel.widthAnchor.constraint(equalToConstant: 0)
        widthBasketButtonImageConstraint?.isActive = true
        widthBasketButtonImageConstraint?.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: topAnchor),
            badgeLabel.rightAnchor.constraint(equalTo: rightAnchor),
            badgeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 30.5)
        ])
    }

    func setBadgeLabelFrame() {
        let newWidth = Const.badgeHeight + ((badgeLabel.text?.count ?? 1) - 1) * 8
        widthBasketButtonImageConstraint?.constant = CGFloat(newWidth)
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.badgeLabel.layoutIfNeeded()
            self?.badgeLabel.layer.cornerRadius = (self?.badgeLabel.bounds.size.height ?? 2) / 2
        }, completion: nil)
    }

    func setVisibleBorders(showBigBorder: Bool) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.layer.borderWidth = showBigBorder ? 1 : 0
            self?.basketButtonImage.layer.borderWidth = showBigBorder ? 0 : 1
        }, completion: nil)
    }

    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        delegate?.basketButtonDidTap()
    }

}

// MARK: Const

private extension BasketButtonView {

    enum Const {

        // badge label
        static let badgeHeight = 13
        static let badgeBackgroundColor = R.color.colors.scarletColor()!

        static func badgeAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: badgeAttributes)
        }

        static let badgeAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.whiteColor()!,
            .font: R.font.sfProTextSemibold(size: 11)!,
            .paragraphStyle: badgeParagraphStyle,
            .backgroundColor: R.color.colors.scarletColor()!
        ]

        static let badgeParagraphStyle: NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byTruncatingTail
            return paragraphStyle
        }()

    }

}
