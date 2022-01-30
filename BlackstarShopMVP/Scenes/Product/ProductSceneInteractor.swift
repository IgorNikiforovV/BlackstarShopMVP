//
//  ProductSceneInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductSceneBusinessLogic {
    func handleAction(request: ProductSceneModels.Request.ActionHandling)
}

protocol ProductSceneInteractorInput {
    var productId: String? { get set }
}

class ProductSceneInteractor: ProductSceneBusinessLogic, ProductSceneInteractorInput {

    var presenter: ProductScenePresentationLogic?
    var productWorker: ProductSceneWorker? = ProductSceneWorker()

    // MARK: ProductSceneInteractorInput

    var productId: String?

    // MARK: ProductBusinessLogic

    func handleAction(request: ProductSceneModels.Request.ActionHandling) {
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

private extension ProductSceneInteractor {

    func fetchData() {
        guard let productId = productId else { return }
        productWorker?.fetchProducts(productId: productId) { result in
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
