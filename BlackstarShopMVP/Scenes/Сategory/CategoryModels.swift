//
//  CategoryModels.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Category {

    enum FetchData {
        struct Request {
            enum RequestType {
                case setScreenState(ScreenState)
                case getData
                case handleCellTap(Int)
            }
        }
        struct Response {
            enum ResponseType {
                case presentCategoryInfo(_ categories: [CategoryInfo])
                case presentSubcategoryInfo(_ subcategories: [SubcategoryInfo])
                case presentError(_ error: String)
                case prepareDataToSubcategoriesRouting(_ subcategories: [SubcategoryInfo])
                case prepareDataToProductsRouting(_ subcategoryId: Int)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewCategories(_ viewModel: [CategoryCellInput])
                case displayError(_ error: String)
                case routeSubcategories(_ state: ScreenState)
            }
        }
    }

}

enum ScreenState {
    case categories
    case subcategories(models: [SubcategoryInfo])
}

struct CategoryCellVModel: CategoryCellInput {
    let picture: URL?
    let title: NSAttributedString
    let icon: URL?
}
