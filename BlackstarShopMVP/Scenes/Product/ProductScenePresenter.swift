//
//  ProductScenePresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 30.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ProductScenePresentationLogic {
    func presentData(response: ProductScene.Model.Response.ResponseType)
}

class ProductScenePresenter: ProductScenePresentationLogic {
    weak var viewController: ProductSceneDisplayLogic?

    func presentData(response: ProductScene.Model.Response.ResponseType) {

    }

}
