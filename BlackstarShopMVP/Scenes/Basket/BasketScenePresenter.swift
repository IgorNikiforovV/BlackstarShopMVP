//
//  BasketScenePresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 05.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol BasketScenePresentationLogic {
    func presentData(with response: BasketScene.StartupData.Response)
    func presentNewStorageData(response: BasketScene.StorageChange.Response)
    func showDeleteBasketItemAlert(response: BasketScene.BasketItemDeleting.Response)
    func showDeleteAllBasketItemsAlert(response: BasketScene.AllBasketItemsDeleting.Response)
    func finishDeleteAlertActions(response: BasketScene.DeleteAlertDisplaying.Response)
    func openMarketTabOrPlaceOrderModule(response: BasketScene.PlaceOrderTapping.Response)
}

class BasketScenePresenter {

    weak var viewController: BasketSceneDisplayLogic?

}

extension BasketScenePresenter: BasketScenePresentationLogic {

    func presentData(with response: BasketScene.StartupData.Response) {
        let basketCells = basketCellViewModels(from: response.basketItems)
        let totalPrice = sumPrices(from: response.basketItems)
        let viewModel = BasketScene.StartupData.ViewModel(basketCells: basketCells, totalPrice: totalPrice)
        viewController?.showInitialBasketProducts(with: viewModel)
    }

    func presentNewStorageData(response request: BasketScene.StorageChange.Response) {
        let basketItems = request.basketItemsChange.changeResults
        let basketCells = basketCellViewModels(from: basketItems)
        let totalPrice = sumPrices(from: basketItems)
        let deletedItemsIndexes = request.basketItemsChange.deleteIndexes
        let insertedItemsIndexes = request.basketItemsChange.insertIndexes
        let viewModel = BasketScene.StorageChange.ViewModel(basketCells: basketCells,
                                                            deletedItemsIndexes: deletedItemsIndexes,
                                                            insertedItemsIndexes: insertedItemsIndexes,
                                                            totalPrice: totalPrice)
        viewController?.showChangedBasketProducts(with: viewModel)
    }

    func showDeleteBasketItemAlert(response request: BasketScene.BasketItemDeleting.Response) {
        viewController?.showDeleteBasketItemAlert(with: BasketScene.BasketItemDeleting.ViewModel())
    }

    func showDeleteAllBasketItemsAlert(response: BasketScene.AllBasketItemsDeleting.Response) {
        viewController?.showDeleteAllBasketItemsAlert(with: BasketScene.AllBasketItemsDeleting.ViewModel())
    }

    func finishDeleteAlertActions(response viewModel: BasketScene.DeleteAlertDisplaying.Response) {
        viewController?.finishDeleteAlertActions(with: BasketScene.DeleteAlertDisplaying.ViewModel())
    }

    func openMarketTabOrPlaceOrderModule(response: BasketScene.PlaceOrderTapping.Response) {
        let viewModel = BasketScene.PlaceOrderTapping.ViewModel(needToGoMarketTab: response.needToGoMarketTab)
        viewController?.openMarketTabOrPlaceOrderModule(with: viewModel)
    }

}

// MARK: private methods

private extension BasketScenePresenter {

    func preparePrice(rowPrice: String) -> String {
        guard let intPrice = Float(rowPrice.trimmingCharacters(in: .whitespaces)) else { return "-" }
        return intPrice.currencyRUB
    }

    func basketCellViewModels(from basketItems: [BasketItem]) -> [BasketCellInput] {
        basketItems.map {
            BasketCellViewModel(imageUrl: $0.imagePath,
                                name: $0.name,
                                size: $0.size,
                                color: $0.colorName,
                                price: preparePrice(rowPrice: $0.price))
        }
    }

    func sumPrices(from basketItems: [BasketItem]) -> String {
        var totalSum: Float = 0
        for item in basketItems {
            if let priceItem = Float(item.price.trimmingCharacters(in: .whitespaces)) {
                totalSum += priceItem
            } else {
                return "Ошибка"
            }
        }
        return totalSum.currencyRUB
    }

}
