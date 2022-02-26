//
//  ProductSceneRouter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 30.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ProductSceneRoutingLogic {
    func showSheetController(sheetInfo: ShadowSheetInfo)
    func returnToPreviousViewController()
    func showBasketSceneTab()
}

class ProductSceneRouter: NSObject, ProductSceneRoutingLogic {

    weak var viewController: ProductSceneViewController?

    // MARK: Routing

    func showSheetController(sheetInfo: ShadowSheetInfo) {
        let sheetController = ShadowActionSheetController(title: sheetInfo.headerText,
                                                          message: nil,
                                                          checkMark: sheetInfo.checkImage)
        for action in sheetInfo.actions {
            sheetController.addAction(action)
        }
        viewController?.present(sheetController, animated: true, completion: nil)
    }

    func returnToPreviousViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func showBasketSceneTab() {
        if let mainTabBarController = viewController?.tabBarController as? MainTabBarController {
            mainTabBarController.switchToBasketTab()
        }
    }

}
