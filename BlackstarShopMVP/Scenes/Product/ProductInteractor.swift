//
//  ProductInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductBusinessLogic {
    func handleAction(request: Product.Request.ActionHandling)
}

protocol ProductInteractorInput {
    var productId: String? { get set }
}

class ProductInteractor: ProductBusinessLogic, ProductInteractorInput {

    var presenter: ProductPresentationLogic?
    var service: ProductService? = ProductService()

    // MARK: ProductInteractorInput

    var productId: String?

    // MARK: ProductBusinessLogic

    func handleAction(request: Product.Request.ActionHandling) {
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

private extension ProductInteractor {

    func fetchData() {
        guard let productId = productId else { return }
        service?.fetchProducts(productId: productId) { result in
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
