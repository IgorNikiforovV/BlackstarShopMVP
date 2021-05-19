//
//  CategoryInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

typealias CategoryRequestType = Category.FetchData.Request.RequestType

protocol CategoryBusinessLogic {
    func makeRequest(request: CategoryRequestType)
}

class CategoryInteractor: CategoryBusinessLogic {

    var presenter: CategoryPresentationLogic?
    var service: CategoryService?

    func makeRequest(request: CategoryRequestType) {
        if service == nil {
            service = CategoryService()
            let result = service!.fetchCategories()

            switch result {
            case .success(let categories):
                presenter?.presentData(response: CategoryResponseType.presentNewCategories(categories))
            case .failure(let error):
                presenter?.presentData(response: CategoryResponseType.presentError(error.localizedDescription))
            }
        }
    }

}
