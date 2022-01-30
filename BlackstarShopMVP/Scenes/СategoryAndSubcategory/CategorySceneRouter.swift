//
//  CategorySceneRouter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CategorySceneRoutingLogic {
    func showSkeleton(for id: String?)
}

class CategorySceneRouter: NSObject, CategorySceneRoutingLogic {
    func showSkeleton(for id: String?) {

    }

    weak var viewController: CategorySceneViewController?

    // MARK: Routing

}
