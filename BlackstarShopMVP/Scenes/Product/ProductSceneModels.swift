//
//  ProductSceneModels.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum ProductSceneModels {

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
            case collectionViewDataReloading(_ seccess: [ProductCellInput])
            case collectionViewFailureReloading(_ failure: String)
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
            case collectionViewDataReloading(_ seccess: [ProductCellInput])
            case collectionViewErrorReloading(_ failure: String)
        }
        enum Routing {
            case productsDetailScene(_ subcategoryId: Int)
        }
    }

}

struct ProductCellItem: ProductCellInput {
    var title: String
    var description: String?
    var picture: String?
    var price: String

    init(productInfo: ProductInfo) {
        title = productInfo.name
        description = productInfo.description
        picture = productInfo.mainImage
        price = String(productInfo.price.split(separator: ".").first ?? "")
    }
}
