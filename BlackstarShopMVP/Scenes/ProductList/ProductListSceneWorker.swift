//
//  ProductListSceneWorker.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

class ProductListSceneWorker {

    var networkService: NetworkService

    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }

    func fetchProducts(subcategoryId: String, completion: @escaping (Result<[String: ProductInfo], NetworkError>) -> Void) {
        networkService.requestData(endPoint: BlackStarShopEndPoint.products(subcategoryId: subcategoryId), completion: completion)
    }

}
