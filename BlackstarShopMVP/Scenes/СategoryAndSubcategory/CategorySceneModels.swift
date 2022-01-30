//
//  CategorySceneModels.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum CategorySceneModels {

    struct Request {
        enum ActionHandling {
            case viewIsReady
            case cellTapped(_ index: Int)
            case didPullToRefresh
        }
    }
    struct Response {
        enum UIConfiguration {
            case navBar(_ title: String)
            case refreshControl
        }
        enum UIUpdating {
            case refreshControlHidding(_ isHidden: Bool)
            case tableViewDataReloading(_ seccess: [CategoryCellModel])
            case tableViewFailureReloading(_ failure: String)
        }
        enum Routing {
            case subcategoriesScene(_ model: CategoryBox)
            case productsScene(_ subcategoryId: Int)
        }
    }
    struct ViewModel {
        enum UIConfiguration {
            case navBarConfiguration(_ model: DisplayedNavBar)
            case refreshControl
        }
        enum UIUpdating {
            case refreshControlHidding(_ isHidden: Bool)
            case tableViewDataReloading(_ seccess: [CategoryCellInput])
            case tableViewErrorReloading(_ failure: String)
        }
        enum Routing {
            case subcategoriesScene(_ model: CategoryBox)
            case productsScene(_ subcategoryId: Int)
        }
    }

}

struct DisplayedNavBar {
    let title: String
    let navigationBarTintColor: UIColor
    let navigationTintColor: UIColor
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
