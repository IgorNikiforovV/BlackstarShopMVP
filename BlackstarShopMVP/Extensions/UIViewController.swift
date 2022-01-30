//
//  UIViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 28.05.2021.
//

import UIKit

protocol Presentable: AnyObject {
    func toPresent() -> UIViewController
}

extension UIViewController: Presentable {

    func toPresent() -> UIViewController {
        return self
    }

}
