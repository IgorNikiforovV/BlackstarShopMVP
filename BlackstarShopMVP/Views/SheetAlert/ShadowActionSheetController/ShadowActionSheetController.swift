import UIKit

struct ShadowSheetAction {
    let attributedTitle: NSAttributedString?
    let leftImages: [UIImage]?
    let rightImages: [UIImage]?
    let centerImages: [UIImage]?
    let selected: Bool
    let completion: () -> Void
}

class ShadowActionSheetController: UIViewController {

    @IBOutlet weak var headerView: ActionSheetHeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableHeightConstrained: NSLayoutConstraint!

    private let checkMarkImage: UIImage?
    private let alertTitle: NSAttributedString?
    private let alertMessage: NSAttributedString?

    private var actions: [ShadowSheetAction] = []
    private let stackView = UIStackView()

    private var fullTableHeight: CGFloat {
        let fullHeight = self.view.frame.size.height - headerView.frame.size.height
        let fullTableHeight = Constants.rowHeight *
                                CGFloat(actions.count) +
                                Constants.bottomHeaderHeight +
                                headerView.frame.size.height
        return fullTableHeight <= fullHeight ? fullTableHeight : fullHeight
    }

    private var rawAllowedTableHeight: CGFloat {
        return Constants.rowHeight *
                Constants.maxAllowedRows +
                headerView.frame.size.height
    }

    private var fullAllowedTableHeight: CGFloat {
        return rawAllowedTableHeight > fullTableHeight ? fullTableHeight : rawAllowedTableHeight
    }

    private enum Constants {
        static let rowHeight: CGFloat = 58.0
        static let bottomHeaderHeight: CGFloat = 38.0
        static let maxAllowedRows: CGFloat = 4.5
    }

    // MARK: Life cycle

    init(title: NSAttributedString?, message: NSAttributedString?, checkMark: UIImage?) {
        self.alertTitle = title
        self.alertMessage = message
        self.checkMarkImage = checkMark
        super.init(nibName: nil, bundle: nil)
        configurePresentation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        Bundle.main.loadNibNamed(String(describing: ShadowActionSheetController.self), owner: self, options: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureTableView()
        configureGestures()
        configureConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureConstraints() // stackview recalculation after viewDidAppear
    }

}

extension ShadowActionSheetController: ShadowActionSheet {

    func showActionSheet(inViewController: UIViewController) {
        if !actions.isEmpty {
            inViewController.present(self, animated: true, completion: nil)
        }
    }

    func addAction(_ action: ShadowSheetAction) {
        actions.append(action)
    }

}

private extension ShadowActionSheetController {

    // MARK: - Actions

    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
        let currentHeight = self.tableHeightConstrained.constant

        if currentHeight == headerView.frame.size.height {
            self.tableHeightConstrained.constant = fullAllowedTableHeight
        }

        if currentHeight == fullAllowedTableHeight {
            self.tableHeightConstrained.constant = fullTableHeight
        }

        if currentHeight == fullTableHeight {
            self.tableHeightConstrained.constant = fullAllowedTableHeight
        }
    }

    private func tableHeightForEndedState(_ velocity: CGFloat, _ newHeight: CGFloat) {
        if newHeight >= 0,
           newHeight <= fullAllowedTableHeight {
            if velocity < -200 {
                self.tableHeightConstrained.constant = fullAllowedTableHeight
            } else if velocity > 200 {
                // commented for non fully dissapearing
                // self.tableHeightConstrained.constant = headerView.frame.size.height
                dismiss(animated: true, completion: nil)
            } else {
                let lowerValue = headerView.frame.size.height
                let lowerRange: ClosedRange<CGFloat> = 0...lowerValue +
                                                        (fullAllowedTableHeight - lowerValue) / 2
                if lowerRange.contains(newHeight) {
                    self.tableHeightConstrained.constant = headerView.frame.size.height
                } else {
                    self.tableHeightConstrained.constant = fullAllowedTableHeight
                }
            }
        } else {
            if velocity < -200 {
                self.tableHeightConstrained.constant = fullTableHeight
            } else if velocity > 200 {
                self.tableHeightConstrained.constant = fullAllowedTableHeight
            } else {
                let lowerValue = fullAllowedTableHeight
                let lowerRange: ClosedRange<CGFloat> = lowerValue...lowerValue +
                    (fullTableHeight - lowerValue) / 2
                if lowerRange.contains(newHeight) {
                    self.tableHeightConstrained.constant = fullAllowedTableHeight
                } else {
                    self.tableHeightConstrained.constant = fullTableHeight
                }
            }
        }
    }

    @objc func panTap(sender: UIPanGestureRecognizer) {
        struct Static {
            static var currentHeight: CGFloat = 0.0
        }

        switch sender.state {
        case .began: Static.currentHeight = self.tableHeightConstrained.constant
        case .changed:
            let newHeight = Static.currentHeight - sender.translation(in: view).y
            if newHeight < fullTableHeight,
                newHeight < self.view.frame.size.height - headerView.frame.size.height,
                newHeight > headerView.frame.size.height {
                self.tableHeightConstrained.constant = Static.currentHeight - sender.translation(in: view).y
            }
        case .ended:
            let velocity = sender.velocity(in: view).y
            let newHeight = Static.currentHeight - sender.translation(in: view).y
            tableHeightForEndedState(velocity, newHeight)
        default:
            break
        }
    }

    // MARK: - Configuration

    func configurePresentation() {
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }

    func configureViews() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15.0
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        if rawAllowedTableHeight > fullTableHeight {
            headerView.draggerView.isHidden = true
        }

        if alertTitle != nil {
            headerView.titleLabel.attributedText = alertTitle
        }

        if alertMessage != nil {
            headerView.messageLabel.attributedText = alertMessage
        }
    }

    func configureTableView() {
        let cell = UINib(nibName: "ActionSheetCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "ActionSheetCell")
        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0.0,
                                                         y: 0.0,
                                                         width: tableView.frame.size.width,
                                                         height: Constants.bottomHeaderHeight))
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = false
        tableView.alwaysBounceVertical = false
        tableView.contentInset = .zero
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        tableView.addTableHeaderViewLine()
    }

    func configureConstraints() {
        self.tableHeightConstrained.constant = self.fullAllowedTableHeight
    }

    func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)

        let subTapGesture = UIGestureRecognizer(target: self, action: #selector(handleTap))
        subTapGesture.cancelsTouchesInView = true
        subTapGesture.isEnabled = false
        subTapGesture.delegate = self
        containerView.addGestureRecognizer(subTapGesture)

        let panGesture = PanDirectionGestureRecognizer(direction: .vertical,
                                                       target: self,
                                                       action: #selector(panTap))
        panGesture.cancelsTouchesInView = true
        headerView.addGestureRecognizer(panGesture)

        let dblTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        dblTapGesture.numberOfTapsRequired = 2
        headerView.addGestureRecognizer(dblTapGesture)
    }
}

extension ShadowActionSheetController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self.view {
            return true
        }
        return false
    }

}

extension ShadowActionSheetController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action: ShadowSheetAction = actions[indexPath.row]
        dismiss(animated: true) {
            action.completion()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension ShadowActionSheetController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActionSheetCell") as? ActionSheetCell else {
            return UITableViewCell()
        }

        let action = actions[indexPath.row]
        cell.textLabel?.attributedText = action.attributedTitle

        if let leftImages = action.leftImages {
             cell.addImages(leftImages, for: .left)
        }

        if let centerImages = action.centerImages {
             cell.addImages(centerImages, for: .center)
        }

        if var rightImages = action.rightImages {
            if checkMarkImage != nil, action.selected {
                rightImages.append(checkMarkImage!)
            }
            cell.addImages(rightImages, for: .right)
        } else {
            if checkMarkImage != nil, action.selected {
                 cell.addImages([checkMarkImage!], for: .right)
            }
        }

        return cell
    }

}

extension ShadowActionSheetController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
        return AlphaTransition(isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
        return AlphaTransition(isPresenting: false)
    }

}
