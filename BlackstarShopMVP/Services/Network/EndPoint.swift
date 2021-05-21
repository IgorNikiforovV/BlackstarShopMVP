//
//  EndPoint.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 20.05.2021.
//

import Foundation

protocol EndPoint {
    var baseURL: URL { get }
    var method: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String?] { get }
    var path: String { get }
    func asURLRequest() -> URLRequest
}

enum BlackStarShopEndPoint: EndPoint {

    case category
    case product(productId: String)

    var baseURL: URL { URL(string: "https://blackstarshop.ru/index.php?route=api/v1/")! }

    var method: String {
        switch self {
        case .category, .product:
            return "GET"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .category, .product:
            return nil
        }
    }

    var headers: [String: String?] {
        switch self {
        case .category, .product:
            return [:]
        }
    }

    var path: String {
        switch self {
        case .category:
            return "categories"
        case .product(let productId):
            return "products&cat_id=\(productId)"
        }
    }

    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method
        request.timeoutInterval = TimeInterval(10 * 1000)
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

}
