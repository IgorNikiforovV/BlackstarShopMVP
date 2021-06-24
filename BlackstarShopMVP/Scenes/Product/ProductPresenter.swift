//
//  ProductPresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductPresentationLogic {
    func prepareUIConfigurationData(response: Category.Response.UIConfiguration)
    func prepareUIUpdatingData(response: Category.Response.UIUpdating)
    func prepareNavigationData(response: Category.Response.Routing)
}

class ProductPresenter: ProductPresentationLogic {

    weak var viewController: ProductDisplayLogic?

    func prepareUIConfigurationData(response: Category.Response.UIConfiguration) {

    }

    func prepareUIUpdatingData(response: Category.Response.UIUpdating) {

    }

    func prepareNavigationData(response: Category.Response.Routing) {

    }

}
