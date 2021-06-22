//
//  CategoryWorker.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class CategoryService {

    var networkService: NetworkService

    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
    }

    func fetchCategories(completion: @escaping (Result<[String: CategoryInfo], NetworkError>) -> Void) {
        networkService.requestData(endPoint: BlackStarShopEndPoint.category, completion: completion)
    }
}
