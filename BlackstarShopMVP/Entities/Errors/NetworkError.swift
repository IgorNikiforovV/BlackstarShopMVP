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
    case noResponseUrl
}

extension NetworkError {

    func description() -> String {
        switch self {
        case .badUrl(let urlString):
            return "Некорректный url: \(urlString)"
        case .transportError(let error):
            return "Ошибка доставки запроса: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Ошибка сети: \(statusCode)"
        case .noData:
            return "Данные не найдены"
        case .decodingError(let error):
            return "Ошибка парсинга данных: \(error.localizedDescription)"
        case .noResponseUrl:
            return "В ответе запроса не пришел url"
        }
    }

    func code() -> Int {
        switch self {
        case .badUrl:
            return 1
        case .transportError:
            return 2
        case .serverError:
            return 3
        case .noData:
            return 4
        case .decodingError:
            return 5
        case .noResponseUrl:
            return 6
        }
    }

}
