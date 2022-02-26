import UIKit

final class ActionSheetHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var draggerView: UIView!

    private var view = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

}

private extension ActionSheetHeaderView {

    func initialize() {
        configureXib()
        configureDragger()
    }

    func configureXib() {
        view = loadNib()
        view.frame = bounds
        covereSuperview(subview: view)
    }

    func configureDragger() {
        draggerView.clipsToBounds = true
        draggerView.layer.borderColor = UIColor.clear.cgColor
        draggerView.layer.cornerRadius = 2.0
    }

}
