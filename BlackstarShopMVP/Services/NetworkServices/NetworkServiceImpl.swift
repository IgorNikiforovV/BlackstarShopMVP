//
//  NetworkServiceImpl.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 20.05.2021.
//

import Foundation

class NetworkServiceImpl: NetworkService {
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func requestData<T: Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        session.dataTask(with: endPoint.asURLRequest()) { data, response, error in
            NetworkLogger.log(response: response as? HTTPURLResponse, data: data, error: error)
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            } else if data == nil {
                completion(.failure(.noData))
                return
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(.failure(.serverError(statusCode: response.statusCode)))
                return
            }

            do {
                let model = try JSONDecoder().decode(T.self, from: data!)
                completion(.success(model))
            } catch let error {
                completion(.failure(.decodingError(error)))
            }
        }
        .resume()

    }
}
