//
//  BasketSceneInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 05.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol BasketSceneBusinessLogic {
    func viewIsReady(request: BasketScene.StartupData.Request)
    func setNotificationStorageSubscribing(request: BasketScene.StorageSubscribing.Request)
    func storageWasChanged(request: BasketScene.StorageChange.Request)
    func deleteBasketItemButtonDidTap(request: BasketScene.BasketItemDeleting.Request)
    func deleteAllBasketItemsButtonDidTap(request: BasketScene.AllBasketItemsDeleting.Request)
    func deleteAlertButtonDidTap(request: BasketScene.DeleteAlertDisplaying.Request)
    func placeOrderTapped(request: BasketScene.PlaceOrderTapping.Request)
}

class BasketSceneInteractor {

    var presenter: BasketScenePresentationLogic?
    var storageService: GlobalBasketStorageService?
    private var basketItems = [BasketItem]()
    private var deletionType: DeletionType?

}

// MARK: BasketSceneBusinessLogic

extension BasketSceneInteractor: BasketSceneBusinessLogic {

    func viewIsReady(request: BasketScene.StartupData.Request) {
        basketItems = storageService?.basketItemsChange?.result ?? []
        presenter?.presentData(with: BasketScene.StartupData.Response(basketItems: basketItems))
    }

    func setNotificationStorageSubscribing(request: BasketScene.StorageSubscribing.Request) {
        storageService?.addObserver(object: request.subscriber)
    }

    func storageWasChanged(request: BasketScene.StorageChange.Request) {
        let basketItemsChange = request.basketItemsChange
        basketItems = basketItemsChange.result
        let request = BasketScene.StorageChange.Response(basketItemsChange: basketItemsChange)
        presenter?.presentNewStorageData(response: request)
    }

    func deleteBasketItemButtonDidTap(request: BasketScene.BasketItemDeleting.Request) {
        guard let basketItem = basketItems[safeIndex: request.index] else {
            print("Index: \(request.index) not found")
            return
        }

        deletionType = .one(basketItem: basketItem)
        presenter?.showDeleteBasketItemAlert(response: BasketScene.BasketItemDeleting.Response())
    }

    func deleteAllBasketItemsButtonDidTap(request: BasketScene.AllBasketItemsDeleting.Request) {
        deletionType = .all
        presenter?.showDeleteAllBasketItemsAlert(response: BasketScene.AllBasketItemsDeleting.Response())
    }

    func deleteAlertButtonDidTap(request: BasketScene.DeleteAlertDisplaying.Request) {
        if request.isDeletionConfirmed, let deletionType = deletionType {
            switch deletionType {
            case .one(let basketItem):
                storageService?.deleteBasketItem(basketItem: basketItem)
            case .all:
                storageService?.deleteAllBasketItems()
            }

            self.deletionType = nil
        }
        presenter?.finishDeleteAlertActions(response: BasketScene.DeleteAlertDisplaying.Response())
    }

    func placeOrderTapped(request: BasketScene.PlaceOrderTapping.Request) {
        let response = BasketScene.PlaceOrderTapping.Response(needToGoMarketTab: basketItems.isEmpty)
        presenter?.openMarketTabOrPlaceOrderModule(response: response)
    }

}
