//
//  ProductPresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductPresentationLogic {
    func prepareUIConfigurationData(response: Product.Response.UIConfiguration)
    func prepareUIUpdatingData(response: Product.Response.UIUpdating)
    func prepareNavigationData(response: Product.Response.Routing)
}

class ProductPresenter: ProductPresentationLogic {

    weak var viewController: ProductDisplayLogic?

    func prepareUIConfigurationData(response: Product.Response.UIConfiguration) {

    }

    func prepareUIUpdatingData(response: Product.Response.UIUpdating) {
        switch response {
        case .refreshControlHidding(_):
            print("refreshControlHidding")
        case .collectionViewDataReloading(let productCellItems):
            viewController?.updateUI(viewModel: .collectionViewDataReloading(productCellItems))
        case .collectionViewFailureReloading(let error):
            viewController?.updateUI(viewModel: .collectionViewErrorReloading(error))
        }
    }

    func prepareNavigationData(response: Product.Response.Routing) {

    }

}
