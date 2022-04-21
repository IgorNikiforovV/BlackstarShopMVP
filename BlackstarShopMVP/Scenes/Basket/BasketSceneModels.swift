//
//  BasketSceneModels.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 05.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum BasketScene {
    enum StartupData {
        struct Request {}
        struct Response {
            let basketItems: [BasketItem]
        }
        struct ViewModel {
            let basketCells: [BasketCellInput]
            let totalPrice: String
        }
    }

    enum StorageSubscribing {
        struct Request {
            let subscriber: BasketItemsSubscribable
        }
        struct Response {}
        struct ViewModel {}
    }

    enum StorageChange {
        struct Request {
            let newBasketItems: [BasketItem]
        }
        struct Response {
            let newBasketItems: [BasketItem]
            let totalPrice: Double
        }
        struct ViewModel {
            let basketCells: [BasketCellInput]
            let totalPrice: String
        }
    }
}
