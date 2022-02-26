//
//  CategorySceneInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol CategorySceneBusinessLogic {
    func handleAction(request: CategorySceneModels.Request.ActionHandling)
}

protocol CategorySceneInteractorInput {
    func setSubcategories(model categoryBox: CategoryBox)
}

class CategorySceneInteractor: CategorySceneBusinessLogic, CategorySceneInteractorInput {

    var presenter: CategoryScenePresentationLogic?
    var categoryWorker: CategorySceneWorker? = CategorySceneWorker()

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

    // MARK: CategoryInteractorInput

    func setSubcategories(model categoryBox: CategoryBox) {
        guard categoryBox.stateScreen == .subcategories else { return }
        self.categories = [categoryBox]
    }


    // MARK: CategoryBusinessLogic

    func handleAction(request: CategorySceneModels.Request.ActionHandling) {
        switch request {
        case .viewIsReady:
            configureUI()
            fetchData()
        case .cellTapped(let index):
            handleCellTap(index)
        case .didPullToRefresh:
            fetchData()
        }
    }

}

// MARK: Private methods

private extension CategorySceneInteractor {

    func configureUI() {
        presenter?.prepareUIConfigurationData(response: .navBar(sceneModeName))
        if sceneMode == .categories {
            presenter?.prepareUIConfigurationData(response: .refreshControl)
        }
    }

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
        categoryWorker?.fetchCategories { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let categoriesResponse):
                    self.categories = self.categoryBox(from: categoriesResponse)
                    self.presenter?.prepareUIUpdatingData(response: .tableViewDataReloading(self.categories.map({ $0.ctegory })))
                case .failure(let error):
                    self.presenter?.prepareUIUpdatingData(response: .tableViewFailureReloading(error.localizedDescription))
                }
            }
        }
    }

    func fetchData() {
        switch sceneMode {
        case .categories:
            loadCategoryInfo()
        case .subcategories:
            if let subcategories = categories.first?.subcategories {
                presenter?.prepareUIUpdatingData(response: .tableViewDataReloading(subcategories))
                presenter?.prepareUIUpdatingData(response: .refreshControlHidding(true))
            }
        }
    }

    func handleCellTap(_ index: Int) {
        switch sceneMode {
        case .categories:
            let categoryBoxItem = categories[index].changeStateScreen(.subcategories)
            presenter?.prepareNavigationData(response: .subcategoriesScene(categoryBoxItem))
        case .subcategories:
            if let subcategoryId = categories.first?.subcategories[index].id {
                presenter?.prepareNavigationData(response: .productListScene(subcategoryId))
            }
        }
    }

}
