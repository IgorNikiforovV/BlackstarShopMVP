//
//  MainTabBarController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 16.05.2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Properties

    let storageService: GlobalBasketStorageService? = GlobalBasketStorageServiceImpl.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMainTabBarControllers()
        setBasketStorageNotification()
    }

}

// MARK: Public methods

extension MainTabBarController {

    func switchToBasketTab() {
        selectedIndex = 1
    }

}

// MARK: Privates methods

private extension MainTabBarController {

    func generateNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }

    func configureMainTabBarControllers() {
        let categoryController = ScenesFactoryImpl.makeCategoriesScene(nil).toPresent()
        let productsController = ScenesFactoryImpl.makeBasketScene().toPresent()
        viewControllers = [
            generateNavController(for: categoryController, title: "Магазин", image: Const.searchIcon),
            generateNavController(for: productsController, title: "Корзина", image: Const.basketIcon)
        ]
    }

    func setBasketStorageNotification() {
        storageService?.addObserver(object: self)
    }

}

extension MainTabBarController: BasketItemsSubscribable {

    func basketItemsDidChange(newBasketItems: [BasketItem]) {
        let badgeValue = newBasketItems.isEmpty ? nil : "\(newBasketItems.count)"
        tabBar.items?[safeIndex: 1]?.badgeValue = badgeValue
    }

}

// MARK: Constants

private extension MainTabBarController {

    enum Const {
        static let searchIcon = R.image.tabBarIcons.search()!
        static let basketIcon = R.image.tabBarIcons.basket()!
    }

}
