//
//  ProductScenePresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ProductScenePresentationLogic {
    func prepareUIConfigurationData(response: ProductSceneModels.Response.UIConfiguration)
    func prepareUIUpdatingData(response: ProductSceneModels.Response.UIUpdating)
    func prepareNavigationData(response: ProductSceneModels.Response.Routing)
}

class ProductScenePresenter: ProductScenePresentationLogic {

    weak var viewController: ProductSceneDisplayLogic?

    func prepareUIConfigurationData(response: ProductSceneModels.Response.UIConfiguration) {

    }

    func prepareUIUpdatingData(response: ProductSceneModels.Response.UIUpdating) {
        switch response {
        case .refreshControlHidding(_):
            print("refreshControlHidding")
        case .collectionViewDataReloading(let productCellItems):
            viewController?.updateUI(viewModel: .collectionViewDataReloading(productCellItems))
        case .collectionViewFailureReloading(let error):
            viewController?.updateUI(viewModel: .collectionViewErrorReloading(error))
        }
    }

    func prepareNavigationData(response: ProductSceneModels.Response.Routing) {

    }

}
