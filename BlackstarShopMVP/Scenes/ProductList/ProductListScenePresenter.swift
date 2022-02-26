//
//  ProductListScenePresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ProductListScenePresentationLogic {
    func prepareUIConfigurationData(response: ProductListSceneModels.Response.UIConfiguration)
    func prepareUIUpdatingData(response: ProductListSceneModels.Response.UIUpdating)
    func prepareNavigationData(response: ProductListSceneModels.Response.Routing)
}

class ProductListScenePresenter: ProductListScenePresentationLogic {

    weak var viewController: ProductListSceneDisplayLogic?

    func prepareUIConfigurationData(response: ProductListSceneModels.Response.UIConfiguration) {

    }

    func prepareUIUpdatingData(response: ProductListSceneModels.Response.UIUpdating) {
        switch response {
        case .refreshControlHidding(_):
            print("refreshControlHidding")
        case .collectionViewDataReloading(let products):
            let cellItems = products.map { ProductCellItem.init(productItem: $0) }
            viewController?.updateUI(viewModel: .collectionViewDataReloading(cellItems))
        case .collectionViewFailureReloading(let error):
            viewController?.updateUI(viewModel: .collectionViewErrorReloading(error))
        }
    }

    func prepareNavigationData(response: ProductListSceneModels.Response.Routing) {
        switch response {
        case .productScene(let product):
            viewController?.navigateToScene(viewModel: .productScene(product))
        }
    }

}
