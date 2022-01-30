//
//  ProductSceneInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 30.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ProductSceneBusinessLogic {
    func makeRequest(request: ProductScene.Model.Request.RequestType)
}

class ProductSceneInteractor: ProductSceneBusinessLogic {

    var presenter: ProductScenePresentationLogic?
    var service: ProductSceneService?

    func makeRequest(request: ProductScene.Model.Request.RequestType) {
        if service == nil {
            service = ProductSceneService()
        }
    }

}
