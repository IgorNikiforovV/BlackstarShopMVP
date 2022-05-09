//
//  ProductSceneModels.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 30.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

enum ProductScene {

    enum StartupData {
        struct Request {}
        struct Response {
            let product: ProductItem?
        }
        struct ViewModel {
            let imageStringUrls: [URL]
            let productName: String
            let price: String
            let description: String?
        }
    }

    enum AddBasketTrapping {
        struct Request {
            let sheetRowAttributtes: [NSAttributedString.Key: Any]
        }
        struct Response {
            let sheetActions: [ShadowSheetAction]
        }
        struct ViewModel {
            let sheetActions: [ShadowSheetAction]
        }
    }

    enum StorageSubscribing {
        struct Request {
            let subscriber: BasketItemsSubscribable
        }
        struct Response {}
        struct ViewModel {}
    }

    enum BasketBageChanging {
        struct Request {
            let count: Int
        }
        struct Response {
            let count: Int
        }
        struct ViewModel {
            let count: Int
        }
    }

}
