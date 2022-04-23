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
    var storageService: GlobalBasketStorageService?

}

// MARK: ProductSceneBusinessLogic

extension ProductSceneInteractor: ProductSceneBusinessLogic {

    func viewIsReady(request: ProductScene.StartupData.Request) {
        setBasketStorageNotification()
        setBasketBage()

        presenter?.presentData(with: ProductScene.StartupData.Response(product: productItem))
    }

    func addBasketTapped(request: ProductScene.AddBasketTrapping.Request) {
        guard let product = productItem else { return }

        if !product.offers.isEmpty {
            let sizesAndActions: [(size: ProductOfferItem, action: () -> Void)] =
            product.offers.enumerated().map { size in
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
        guard let productItem = productItem?.with(newSelectedSizeIndex: index) else { return }
        self.productItem = productItem

        saveProductItemToBasket(productItem: productItem)
    }

    func saveProductItemToBasket(productItem: ProductItem) {
        let basketItem = BasketItem.basketItem(from: productItem)
        storageService?.addBasketItem(newBasketItem: basketItem)
    }

    func setBasketStorageNotification() {
        storageService?.addObserver(object: self)
    }

    func setBasketBage() {
        let bageValue = storageService?.basketItemsChange?.result.count ?? 0
        presenter?.changeBasketBage(with: ProductScene.BasketBageChanging.Response(count: bageValue))
    }

}

extension ProductSceneInteractor: BasketItemsSubscribable {

    func basketItemsDidChange(basketItemsChange: DomainDatabaseChange<BasketItem>) {
        let newBasketItemsCount = basketItemsChange.result.count
        presenter?.changeBasketBage(with: ProductScene.BasketBageChanging.Response(count: newBasketItemsCount))
    }

}
