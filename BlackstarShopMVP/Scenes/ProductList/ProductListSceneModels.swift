//
//  ProductListSceneModels.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

enum ProductListSceneModels {

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
            case collectionViewDataReloading(_ seccess: [ProductItem])
            case collectionViewFailureReloading(_ failure: String)
        }
        enum Routing {
            case productScene(_ product: ProductItem)
        }
    }
    struct ViewModel {
        enum UIConfiguration {
            case navBarConfiguration(_ model: DisplayedNavBar)
            case refreshControl
        }
        enum UIUpdating {
            case refreshControlHidding(_ isHidden: Bool)
            case collectionViewDataReloading(_ seccess: [ProductCellInput])
            case collectionViewErrorReloading(_ failure: String)
        }
        enum Routing {
            case productScene(_ product: ProductItem)
        }
    }

}

struct ProductCellItem: ProductCellInput {
    var title: String
    var description: String?
    var picture: String?
    var price: String

    init(productItem: ProductItem) {
        title = productItem.name
        description = productItem.description
        picture = productItem.mainImage
        price = String(productItem.price.split(separator: ".").first ?? "")
    }
}
