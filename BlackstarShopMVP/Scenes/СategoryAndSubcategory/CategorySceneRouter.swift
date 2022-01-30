//
//  CategorySceneRouter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CategorySceneRoutingLogic {
    func showSubcategoryScene(categoryBox: CategoryBox)
    func showProductScene(productId: String)
}

class CategorySceneRouter: NSObject, CategorySceneRoutingLogic {

    weak var viewController: CategorySceneViewController?

    // MARK: Routing

    func showSubcategoryScene(categoryBox: CategoryBox) {
        viewController?.navigationController?.modalPresentationStyle = .fullScreen
        viewController?.navigationController?.modalTransitionStyle = .partialCurl
        let subcategories = ScenesFactoryImpl.makeCategoriesScene(categoryBox).toPresent()
        viewController?.navigationController?.pushViewController(subcategories, animated: true)
    }

    func showProductScene(productId: String) {
        let productSceneViewController = ScenesFactoryImpl.makeProductScene(productId).toPresent()
        viewController?.navigationController?.pushViewController(productSceneViewController, animated: true)
    }

}
