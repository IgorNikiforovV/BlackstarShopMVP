import UIKit

enum ImageContainers {
    case left
    case right
    case center
}

final class ActionSheetCell: UITableViewCell {

    // MARK: @IBOutlet

    @IBOutlet private weak var centerLabel: UILabel!
    @IBOutlet private weak var leftStackView: UIStackView!
    @IBOutlet private weak var centerStackView: UIStackView!
    @IBOutlet private weak var rightStackView: UIStackView!

    @IBOutlet private weak var fromLeftStackToLeadingConstraint: NSLayoutConstraint!

    override var textLabel: UILabel? {
        return centerLabel
    }

    func addImages(_ images: [UIImage], for side: ImageContainers) {
        var container: UIStackView

        switch side {
        case .left:
            container = leftStackView
            fromLeftStackToLeadingConstraint.constant = 16
        case .right:
            container = rightStackView
        case .center:
            container = centerStackView
        }

        for image in images {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            container.addArrangedSubview(imageView)
        }
    }

}

extension ActionSheetCell {

    // MARK: Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        leftStackView.axis = .horizontal
        leftStackView.distribution = .fillProportionally
        leftStackView.spacing = Const.imagePadding
        leftStackView.alignment = .center
        leftStackView.layoutMargins = UIEdgeInsets(top: 0,
                                                   left: Const.imagePadding,
                                                   bottom: 0,
                                                   right: Const.imagePadding)

        rightStackView.axis = .horizontal
        rightStackView.distribution = .fillProportionally
        rightStackView.spacing = Const.imagePadding
        rightStackView.alignment = .center
        rightStackView.layoutMargins = UIEdgeInsets(top: 0,
                                                    left: Const.imagePadding,
                                                    bottom: 0,
                                                    right: Const.imagePadding)

        centerStackView.axis = .horizontal
        centerStackView.distribution = .fillProportionally
        centerStackView.spacing = Const.imagePadding
        centerStackView.alignment = .center
        centerStackView.layoutMargins = UIEdgeInsets(top: 0,
                                                     left: Const.imagePadding,
                                                     bottom: 0,
                                                     right: Const.imagePadding)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        fromLeftStackToLeadingConstraint.constant = 0
        leftStackView.subviews.forEach { view in
            leftStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        rightStackView.subviews.forEach { view in
            rightStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        centerStackView.subviews.forEach { view in
            centerStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

}

extension ActionSheetCell {

    enum Const {

         static let leftImageWidth: CGFloat = 26.0
         static let leftImageHeight: CGFloat = 26.0
         static let rightImageWidth: CGFloat = 26.0
         static let rightImageHeight: CGFloat = 26.0
         static let imagePadding: CGFloat = 10.0

     }

}
