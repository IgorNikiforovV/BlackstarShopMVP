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

    private var products = [ProductItem]()

    // MARK: СollectionSceneInteractorInput

    var subcategoryId: String?

    // MARK: СollectionBusinessLogic

    func handleAction(request: ProductListSceneModels.Request.ActionHandling) {
        switch request {
        case .viewIsReady:
            fetchData()
        case .cellTapped(let index):
            guard let product = products[safeIndex: index] else { return }
            presenter?.prepareNavigationData(response: .productScene(product))
        case .didPullToRefresh:
            print("didPullToRefresh")
        }
    }

}

// MARK: Private methods

private extension ProductListSceneInteractor {

    func fetchData() {
        guard let subcategoryId = subcategoryId else { return }
        productListWorker?.fetchProducts(subcategoryId: subcategoryId) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleFetchDataResult(result: result)
            }
        }
    }

    func handleFetchDataResult(result: Result<[String: ProductInfo], NetworkError>) {
        switch result {
        case .success(let productsInfo):
            products = productsInfo
            .map { ProductItem.productItem(id: $0.key, from: $0.value) }
            .sorted { $0.sortOrder > $1.sortOrder }
            presenter?.prepareUIUpdatingData(response: .collectionViewDataReloading(products))
        case .failure(let error):
            presenter?.prepareUIUpdatingData(response: .collectionViewFailureReloading(error.localizedDescription))
        }
    }

}
