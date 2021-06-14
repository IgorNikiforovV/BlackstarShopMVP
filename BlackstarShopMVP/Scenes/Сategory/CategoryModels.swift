//
//  CategoryModels.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Category {

    enum ConfigureUI {
        struct Request {}
        struct Response {
            let navBarTitle: String
        }
        struct ViewModel {
            struct DisplayedNavBar {
                let title: String
                let navigationBarTintColor: UIColor
                let navigationTintColor: UIColor
            }
        }
    }

    enum FetchData {
        struct Request {}
        struct Response {
            enum ResponseData {
                case success([CategoryCellModel])
                case failure(String)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewCategories(_ viewModel: [CategoryCellInput])
                case displayError(_ error: String)
            }
        }
    }

    enum NavigateToScene {
        struct Request {
            let index: Int
        }
        struct Response {
            enum PrepareData {
                case prepareDataToSubcategoriesScene(_ model: CategoryBox)
                case prepareDataToProductsScene(_ subcategoryId: Int)
            }
        }
        struct ViewModel {
            enum NavigateToAnotherScene {
                case routeSubcategories(_ model: CategoryBox)
                case routeProducts(_ subcategoryId: Int)
            }
        }
    }

}

enum CategoryScreenMode {
    case categories
    case subcategories
}

protocol CategoryCellModel {
    var id: Int { get }
    var picture: String? { get }
    var title: String { get }
    var icon: String? { get }
}

struct SimpleCategory: CategoryCellModel {
    var id: Int
    let picture: String?
    let title: String
    let icon: String?

    init(categoryInfo: CategoryInfo) {
        id = 0
        picture = categoryInfo.image
        title = categoryInfo.name
        icon = categoryInfo.iconImage
    }

    init(subcategoryInfo: SubcategoryInfo) {
        id = subcategoryInfo.id
        picture = subcategoryInfo.iconImage
        title = subcategoryInfo.name ?? ""
        icon = nil
    }

    static func simpleSubcategories(from subcategoriesInfo: [SubcategoryInfo]) -> [SimpleCategory] {
        subcategoriesInfo.map { .init(subcategoryInfo: $0) }
    }

}

struct CategoryBox {
    let stateScreen: CategoryScreenMode
    let ctegory: CategoryCellModel
    let subcategories: [CategoryCellModel]

    func changeStateScreen(_ newState: CategoryScreenMode) -> CategoryBox {
        CategoryBox(stateScreen: newState, ctegory: self.ctegory, subcategories: self.subcategories)
    }
}

struct CategoryNavBarVM {
    let title: String
    let navigationBarTintColor: UIColor
    let navigationTintColor: UIColor
}

struct CategoryCellVM: CategoryCellInput {
    let id: Int
    let picture: URL?
    let title: NSAttributedString
    let icon: URL?
}
