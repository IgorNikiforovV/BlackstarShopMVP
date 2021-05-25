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

    private var categories = [CategoryInfo]()
    private var screenState: ScreenState = .categories

    func makeRequest(request: Category.FetchData.Request.RequestType) {
        switch request {
        case .getData:
            switch screenState {
            case .categories:
                loadCategoryInfo()
            case .subcategories(let viewModels):
                presenter?.presentData(response: .presentSubcategoryInfo(viewModels))
            }

        case .setScreenState(let screenState):
            self.screenState = screenState
        }
    }

}

// MARK: Private methods

private extension CategoryInteractor {

    func loadCategoryInfo() {
        service = CategoryService()

        service?.fetchCategories { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let categoriesResponse):
                    self.categories = categoriesResponse.map { $0.value }
                    self.presenter?.presentData(response: .presentCategoryInfo(self.categories))
                case .failure(let error):
                    print(error.localizedDescription)
                    self.presenter?.presentData(response: .presentError(error.localizedDescription))
                }
            }
        }
    }

}
