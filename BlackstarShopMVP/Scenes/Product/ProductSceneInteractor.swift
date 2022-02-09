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
}

class ProductSceneInteractor: ProductSceneBusinessLogic {
    var productItem: ProductItem?

    var presenter: ProductScenePresentationLogic?
    var service: ProductSceneService?

    func viewIsReady(request: ProductScene.StartupData.Request) {
        presenter?.presentData(response: ProductScene.StartupData.Response(product: productItem))
    }

}
