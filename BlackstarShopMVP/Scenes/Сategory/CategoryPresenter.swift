//
//  CategoryPresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol CategoryPresentationLogic {
    func presentData(response: Category.Model.Response.ResponseType)
}

class CategoryPresenter: CategoryPresentationLogic {
    weak var viewController: CategoryDisplayLogic?

    func presentData(response: Category.Model.Response.ResponseType) {

    }

}
