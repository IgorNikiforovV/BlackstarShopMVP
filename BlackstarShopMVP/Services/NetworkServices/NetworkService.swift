//
//  NetworkService.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 20.05.2021.
//

import Foundation

protocol NetworkService {
    func requestData<T: Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, NetworkError>) -> Void)
}

extension NetworkService {
    func requestData<T: Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        NetworkLogger.log(request: endPoint.asURLRequest())
    }
}
