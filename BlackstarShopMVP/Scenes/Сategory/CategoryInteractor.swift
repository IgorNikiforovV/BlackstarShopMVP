//
//  CategoryInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol CategoryBusinessLogic {
    func configureUI(request: Category.ConfigureUI.Request)
    func fetchData(request: Category.FetchData.Request)
    func navigateToScene(request: Category.NavigateToScene.Request)
}

class CategoryInteractor: CategoryBusinessLogic {

    var presenter: CategoryPresentationLogic?
    var service: CategoryService? = CategoryService()

    private var categories = [CategoryBox]()
    private var sceneMode: CategoryScreenMode {
        guard !categories.isEmpty else { return .categories }
        return categories.filter { $0.stateScreen == .categories }.isEmpty ? .subcategories : .categories
    }
    private var sceneModeName: String {
        switch sceneMode {
        case .categories:
            return "Категории"
        case .subcategories:
            return categories.first?.ctegory.title ?? ""
        }
    }

    func configureUI(request: Category.ConfigureUI.Request) {
        presenter?.prepareUISettings(response: .init(navBarTitle: sceneModeName))
    }

    func fetchData(request: Category.FetchData.Request) {
        switch sceneMode {
        case .categories:
            loadCategoryInfo()
        case .subcategories:
            if let subcategories = categories.first?.subcategories {
                presenter?.prepareContentData(response: .success(subcategories))
            }
        }
    }

    func navigateToScene(request: Category.NavigateToScene.Request) {
        switch sceneMode {
        case .categories:
            let categoryBoxItem = categories[request.index].changeStateScreen(.subcategories)
            presenter?.prepareNavigationData(response: .prepareDataToSubcategoriesScene(categoryBoxItem))
        case .subcategories:
            if let subcategoryId = categories.first?.subcategories[request.index].id {
                presenter?.prepareNavigationData(response: .prepareDataToProductsScene(subcategoryId))
            }
        }
    }

}

// MARK: Public methods

extension CategoryInteractor {

    func setSubcategories(model categoryBox: CategoryBox) {
        guard categoryBox.stateScreen == .subcategories else { return }
        self.categories = [categoryBox]
    }

}

// MARK: Private methods

private extension CategoryInteractor {

    func categoryBox(from categoriesResponse: [String: CategoryInfo]) -> [CategoryBox] {
        categoriesResponse
            .map { $0.value }
            .filter { !$0.subcategories.isEmpty }
            .sorted(by: { $0.sortOrder < $1.sortOrder })
            .map {
                CategoryBox(
                    stateScreen: .categories,
                    ctegory: SimpleCategory(categoryInfo: $0),
                    subcategories: SimpleCategory.simpleSubcategories(from: $0.subcategories)
                )
            }
    }

    func loadCategoryInfo() {
        service?.fetchCategories { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let categoriesResponse):
                    self.categories = self.categoryBox(from: categoriesResponse)
                    self.presenter?.prepareContentData(response: .success(self.categories.map({ $0.ctegory })))
                case .failure(let error):
                    self.presenter?.prepareContentData(response: .failure(error.localizedDescription))
                }
            }
        }
    }

}
