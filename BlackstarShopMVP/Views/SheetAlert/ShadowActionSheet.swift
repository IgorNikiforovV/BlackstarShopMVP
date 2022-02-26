import UIKit

protocol ShadowActionSheet {
    func showActionSheet(inViewController: UIViewController)
    func addAction(_ action: ShadowSheetAction)
}
