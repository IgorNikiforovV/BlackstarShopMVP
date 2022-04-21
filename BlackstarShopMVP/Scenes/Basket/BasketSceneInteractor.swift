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
}

class BasketSceneInteractor {

    var presenter: BasketScenePresentationLogic?
    var storageService: GlobalBasketStorageService?
    private var basketItems = [BasketItem]()

}

// MARK: BasketSceneBusinessLogic

extension BasketSceneInteractor: BasketSceneBusinessLogic {

    func viewIsReady(request: BasketScene.StartupData.Request) {
        basketItems = storageService?.basketItems ?? []
        presenter?.presentData(with: BasketScene.StartupData.Response(basketItems: basketItems))
    }

    func setNotificationStorageSubscribing(request: BasketScene.StorageSubscribing.Request) {
        storageService?.addObserver(object: request.subscriber)
    }

    func storageWasChanged(request: BasketScene.StorageChange.Request) {
        basketItems = request.newBasketItems
    }

}
