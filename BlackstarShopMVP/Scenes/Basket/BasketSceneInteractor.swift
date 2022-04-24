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
}

class BasketSceneInteractor {

    var presenter: BasketScenePresentationLogic?
    var storageService: GlobalBasketStorageService?
    private var basketItems = [BasketItem]()

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
        presenter?.presentNewStorageData(request: request)
    }

    func deleteBasketItemButtonDidTap(request: BasketScene.BasketItemDeleting.Request) {
        guard let basketItem = basketItems[safeIndex: request.index] else {
            print("Index: \(request.index) not found")
            return
        }

        storageService?.deleteBasketItem(basketItem: basketItem)
    }

    func deleteAllBasketItemsButtonDidTap(request: BasketScene.AllBasketItemsDeleting.Request) {
        storageService?.deleteAllBasketItems()
    }

}
