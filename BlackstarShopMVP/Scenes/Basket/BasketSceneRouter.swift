//
//  BasketSceneRouter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 05.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol BasketSceneRoutingLogic {
    func showMarketTab()
}

class BasketSceneRouter: NSObject, BasketSceneRoutingLogic {

    weak var viewController: BasketSceneViewController?

    // MARK: Routing

    func showMarketTab() {
        if let mainTabBarController = viewController?.tabBarController as? MainTabBarController {
            mainTabBarController.switchToMarketTab()
        }
    }

}
