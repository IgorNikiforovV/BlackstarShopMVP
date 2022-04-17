//
//  BasketSceneInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 05.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol BasketSceneBusinessLogic {
    func makeRequest(request: BasketScene.Model.Request.RequestType)
}

class BasketSceneInteractor: BasketSceneBusinessLogic {

    var presenter: BasketScenePresentationLogic?
    var storageService: GlobalBasketStorageService?

    func makeRequest(request: BasketScene.Model.Request.RequestType) {
    }

}
