//
//  NetworkError.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 20.05.2021.
//

enum NetworkError: Error {
    case badUrl(String)
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}
