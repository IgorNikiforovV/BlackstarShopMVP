//
//  UITableView.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 20.02.2022.
//

import UIKit

extension UITableView {

    func addTableHeaderViewLine() {
        self.tableHeaderView = {
            let line = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1 / UIScreen.main.scale))
            line.backgroundColor = self.separatorColor
            return line
        }()
    }

    func setEmptyMessage(_ attributedMessage: NSAttributedString) {
        let messageLabel = UILabel(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: bounds.size.width,
                                                 height: bounds.size.height))

        messageLabel.attributedText = attributedMessage
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()

        backgroundView = messageLabel
    }

    func restore() {
        backgroundView = nil
    }

}
