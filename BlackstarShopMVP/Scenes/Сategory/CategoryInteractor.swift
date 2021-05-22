//
//  CategoryInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CategoryBusinessLogic {
    func makeRequest(request: Category.FetchData.Request.RequestType)
}

class CategoryInteractor: CategoryBusinessLogic {

    var presenter: CategoryPresentationLogic?
    var service: CategoryService?

    func makeRequest(request: Category.FetchData.Request.RequestType) {
        if service == nil {
            service = CategoryService()
            service!.fetchCategories { result in
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success(let categoriesResponse):
                        self?.presenter?.presentData(response: .presentNewCategories(categoriesResponse))
                    case .failure(let error):
                        print(error.localizedDescription)
                        self?.presenter?.presentData(response: .presentError(error.localizedDescription))
                    }
                }
            }
        }
    }

}
