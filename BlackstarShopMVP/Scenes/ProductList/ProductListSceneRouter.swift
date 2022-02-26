//
//  ProductListSceneRouter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductListSceneRoutingLogic {
    func showProductScene(product: ProductItem)
}

class ProductListSceneRouter: NSObject, ProductListSceneRoutingLogic {

    weak var viewController: ProductListSceneViewController?

    // MARK: Routing

    func showProductScene(product: ProductItem) {
        let productListSceneViewController = ScenesFactoryImpl.makeProductScene(product).toPresent()
        viewController?.navigationController?.pushViewController(productListSceneViewController, animated: true)
    }

}
