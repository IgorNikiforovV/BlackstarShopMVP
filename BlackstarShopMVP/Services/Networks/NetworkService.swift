//
//  NetworkService.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 20.05.2021.
//

protocol NetworkService {
    func requestData<T: Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, NetworkError>) -> Void)
}
