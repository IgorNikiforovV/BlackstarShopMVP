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
            let basketItemsChange: DomainDatabaseChange<BasketItem>
        }
        struct Response {
            let basketItemsChange: DomainDatabaseChange<BasketItem>
        }
        struct ViewModel {
            let basketCells: [BasketCellInput]
            let deletedItemsIndexes: [Int]
            let insertedItemsIndexes: [Int]
            let totalPrice: String
        }
    }

    enum BasketItemDeleting {
        struct Request {
            let index: Int
        }
        struct Response {}
        struct ViewModel {}
    }

    enum AllBasketItemsDeleting {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }

    enum DeleteAlertDisplaying {
        struct Request {
            let isDeletionConfirmed: Bool
        }
        struct Response {}
        struct ViewModel {}
    }

}
