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
            }
        }
        struct Response {
            enum ResponseType {
                case presentCategoryInfo(_ categories: [CategoryInfo])
                case presentSubcategoryInfo(_ subcategories: [SubcategoryInfo])
                case presentError(_ error: String)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewCategories(_ viewModel: [CategoryCellInput])
                case displayError(_ error: String)
            }
        }
    }

}

enum ScreenState {
    case categories
    case subcategories(viewModels: [SubcategoryInfo])
}

struct CategoryCellVModel: CategoryCellInput {
    let picture: URL?
    let title: NSAttributedString
    let icon: URL?
}
