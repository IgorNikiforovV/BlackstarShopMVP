//
//  ProductListSceneInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductListSceneBusinessLogic {
    func handleAction(request: ProductListSceneModels.Request.ActionHandling)
}

protocol ProductListSceneInteractorInput {
    var subcategoryId: String? { get set }
}

class ProductListSceneInteractor: ProductListSceneBusinessLogic, ProductListSceneInteractorInput {

    var presenter: ProductListScenePresentationLogic?
    var productListWorker: ProductListSceneWorker? = ProductListSceneWorker()

    // MARK: СollectionSceneInteractorInput

    var subcategoryId: String?

    // MARK: СollectionBusinessLogic

    func handleAction(request: ProductListSceneModels.Request.ActionHandling) {
        switch request {
        case .viewIsReady:
            fetchData()
        case .cellTapped(_):
            print("cellTapped")
        case .didPullToRefresh:
            print("didPullToRefresh")
        }
    }

}

// MARK: Private methods

private extension ProductListSceneInteractor {

    func fetchData() {
        guard let subcategoryId = subcategoryId else { return }
        productListWorker?.fetchProducts(subcategoryId: subcategoryId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let productsInfo):
                    let products = productsInfo
                        .map { $0.value }
                        .sorted { $0.sortOrder > $1.sortOrder }
                    let cellItems = products.map { ProductCellItem.init(productInfo: $0) }
                    self.presenter?.prepareUIUpdatingData(response: .collectionViewDataReloading(cellItems))
                case .failure(let error):
                    self.presenter?.prepareUIUpdatingData(response: .collectionViewFailureReloading(error.localizedDescription))
                }
            }
        }
    }

}
