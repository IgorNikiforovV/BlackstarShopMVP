//
//  ProductModels.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Product {

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
            case productsDetailScene(_ subcategoryId: Int)
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
            case productsDetailScene(_ subcategoryId: Int)
        }
    }

}

struct ProductCellModel: ProductCellInput {
    var id: Int
    var title: String
    var description: String
    var picture: String?
    var price: String
}
