//
//  ProductWorker.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class ProductService {

    var networkService: NetworkService

    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }

    func fetchProducts(productId: String, completion: @escaping (Result<[String: ProductInfo], NetworkError>) -> Void) {
        networkService.requestData(endPoint: BlackStarShopEndPoint.product(productId: productId), completion: completion)
    }

}
