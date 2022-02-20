//
//  ProductSceneInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 30.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ProductSceneBusinessLogic {
    func viewIsReady(request: ProductScene.StartupData.Request)
    func addBasketTapped(request: ProductScene.AddBasketTrapping.Request)
}

class ProductSceneInteractor {

    var productItem: ProductItem?

    var presenter: ProductScenePresentationLogic?
    var service: ProductSceneService?

}

// MARK: ProductSceneBusinessLogic

extension ProductSceneInteractor: ProductSceneBusinessLogic {

    func viewIsReady(request: ProductScene.StartupData.Request) {
        presenter?.presentData(with: ProductScene.StartupData.Response(product: productItem))
    }

    func addBasketTapped(request: ProductScene.AddBasketTrapping.Request) {
        guard let product = productItem else { return }

        if !product.offers.isEmpty {
            let sortedSizeList = product.offers.sorted { size1, size2 in size1.quantity < size2.quantity }
            let sizesAndActions: [(size: ProductOfferItem, action: () -> Void)] =
            sortedSizeList.enumerated().map { size in
                let action: () -> Void = { [weak self] in self?.chooseSize(index: size.offset) }
                return (size.element, action)
            }
            let sheetSizeActions = SheetActionService.sheetSizeActions(from: sizesAndActions,
                                                                       and: product.selectedSizeIndex ?? 0,
                                                                       with: request.sheetRowAttributtes)
            presenter?.prepareSizesSheetData(with: ProductScene.AddBasketTrapping.Response(sheetActions: sheetSizeActions))
        }
    }

}

// MARK: private methods

private extension ProductSceneInteractor {

    func chooseSize(index: Int) {
        print(index)
    }

}
