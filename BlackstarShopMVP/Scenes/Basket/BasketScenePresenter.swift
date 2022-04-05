//
//  BasketScenePresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 05.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol BasketScenePresentationLogic {
    func presentData(response: BasketScene.Model.Response.ResponseType)
}

class BasketScenePresenter: BasketScenePresentationLogic {
    weak var viewController: BasketSceneDisplayLogic?

    func presentData(response: BasketScene.Model.Response.ResponseType) {

    }

}
