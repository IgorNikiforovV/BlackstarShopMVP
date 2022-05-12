//
//  AlertView.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 26.04.2022.
//

import UIKit

protocol AlertViewDelegate: AnyObject {
    func okButtonDidTap()
    func cancelButtonDidTap()
}

protocol AlertViewInput {
    var title: String { get }
    var okButtonTitle: String { get }
    var cancelButtonTitle: String? { get }
}

class AlertView: UIView {

    // MARK: @IBOutlet

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var okButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!

    // MARK: Properties

    weak var delegate: AlertViewDelegate?

    // MARK: - Object lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

}

// MARK: - Public methods

extension AlertView {
    func configure(model: AlertViewInput, parentView: UIView) {
        titleLabel.attributedText = Const.titleAttributedText(model.title)

        okButton.setAttributedTitle(Const.okTitleAttributedText(model.okButtonTitle), for: .normal)
        if let cancelButtonTitle = model.cancelButtonTitle {
            cancelButton.setAttributedTitle(Const.cancelTitleAttributedText(cancelButtonTitle), for: .normal)
            cancelButton.isHidden = false
        } else {
            cancelButton.isHidden = true
        }

        parentView.addSubview(self)
        self.frame = parentView.frame
        self.center = parentView.center

        startAlertAnimation()
    }
}

// MARK: - Private methods

private extension AlertView {
    func initialize() {
        contentView = loadNib()
        contentView.frame = bounds
        self.covereSuperview(subview: contentView)

        self.alpha = 0
        backgroundView.alpha = 0.4
        alertView.backgroundColor = Const.contentBackgroundColor
        alertView.layer.cornerRadius = Const.contentCornerRadius

        okButton.backgroundColor = Const.okBackgroundColor
        okButton.layer.cornerRadius = Const.okCornerRadius


        cancelButton.backgroundColor = Const.cancelBackgroundColor
        cancelButton.layer.cornerRadius = Const.cancelCornerRadius
        cancelButton.layer.borderWidth = Const.cancelBorderWidth
        cancelButton.layer.borderColor = Const.cancelBorderColor
    }

    func startAlertAnimation() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveLinear) {
            self.alpha = 1
        }
    }


    func finishAlertAnimation() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveLinear) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

    @IBAction func okButtonDidTap(_ sender: UIButton) {
        finishAlertAnimation()
        delegate?.okButtonDidTap()
    }
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        finishAlertAnimation()
        delegate?.cancelButtonDidTap()
    }
}

private extension AlertView {

    enum Const {

        // content view
        static let contentCornerRadius: CGFloat = 8
        static let contentBackgroundColor = R.color.colors.whiteColor()!

        // title label
        static func titleAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: titleAttributes)
        }

        static let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.blackColor()!,
            .font: R.font.sfProDisplayMedium(size: 18)!,
            .paragraphStyle: titleParagraphStyle
        ]

        static let titleParagraphStyle: NSMutableParagraphStyle = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.74
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byTruncatingTail
            return paragraphStyle
        }()

        // ok button
        static let okBackgroundColor = R.color.colors.blueColor()!
        static let okCornerRadius: CGFloat = 8

        static func okTitleAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: okTitleAttributes)
        }

        static let okTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.whiteColor()!,
            .font: R.font.sfProTextRegular(size: 16)!
        ]

        // cancel button
        static let cancelBackgroundColor = R.color.colors.whiteColor()!
        static let cancelCornerRadius: CGFloat = 8
        static let cancelBorderColor = R.color.colors.grayColor()!.cgColor
        static let cancelBorderWidth: CGFloat = 1

        static func cancelTitleAttributedText(_ text: String) -> NSAttributedString {
            .init(string: text, attributes: cancelTitleAttributes)
        }

        static let cancelTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.color.colors.blackColor()!,
            .font: R.font.sfProTextRegular(size: 16)!
        ]

    }

}
