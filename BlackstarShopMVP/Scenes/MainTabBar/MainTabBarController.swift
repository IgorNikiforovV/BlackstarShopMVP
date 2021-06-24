//
//  MainTabBarController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 16.05.2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMainTabBarControllers()
    }

}

// MARK: Privates methods

private extension MainTabBarController {

    func generateNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        print("rootViewController: ", rootViewController)
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }

    func configureMainTabBarControllers() {
        let categoryController = ScenesFactoryImpl.makeCategoriesScene(nil).toPresent()
        let productController = ScenesFactoryImpl.makeProductScene(67).toPresent()
        viewControllers = [
            generateNavController(for: categoryController, title: "Магазин", image: Const.searchIcon),
            generateNavController(for: productController, title: "Корзина", image: Const.basketIcon)
        ]
    }

}

// MARK: Constants

private extension MainTabBarController {

    enum Const {
        static let searchIcon = R.image.tabBarIcons.search()!
        static let basketIcon = R.image.tabBarIcons.basket()!
    }

}
