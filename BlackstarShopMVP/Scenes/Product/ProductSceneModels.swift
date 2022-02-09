//
//  ProductSceneModels.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 30.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

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

}
