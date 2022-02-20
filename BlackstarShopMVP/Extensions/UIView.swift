//
//  UIView.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 20.02.2022.
//

import UIKit

extension UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        guard let nibName = Self.description().components(separatedBy: ".").last else { return UIView() }
        let nib = UINib(nibName: nibName, bundle: bundle)
        return (nib.instantiate(withOwner: self, options: nil).first as? UIView) ?? UIView()
    }
}

extension UIView {
    func covereSuperview(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
