//
//  DownloadImagesService.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 06.02.2022.
//

import Foundation

typealias ImageResult = (url: String, data: Data)

protocol DownloadImagesService {
    func downloadImages(by imageUrls: [URL], completion: @escaping (Result<[Data], NetworkError>) -> Void)
}

class DownloadImagesServiceImpl: DownloadImagesService {
    private var imageUrls = [String]()
    private let imageDownloadGroup = DispatchGroup()
    private let imageDownloadQueue = DispatchQueue(label: "ru.blackStartShop.download.images", qos: .userInitiated)

    // данный метод выкачивает все изображения за раз и сортирует их в зависимости от url
    func downloadImages(by imageUrls: [URL], completion: @escaping (Result<[Data], NetworkError>) -> Void) {
        self.imageUrls = imageUrls.map { $0.absoluteString }

        var outputDataImages = [ImageResult]()

        for url in imageUrls {
            imageDownloadGroup.enter()
            URLSession.shared.dataTask(with: url) { [weak self] date, response, error in
                guard let self = self else { return }
                defer { self.imageDownloadGroup.leave() }

                let handledResult = self.handleResponse(data: date, response: response, error: error)

                switch handledResult {
                case .success(let imageResult):
                    outputDataImages.append(imageResult)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            .resume()
        }

        imageDownloadGroup.notify(queue: imageDownloadQueue) {
            let sortedLoadedImageDatas = self.sortLoadedImageDatas(outputDataImages)
            completion(.success(sortedLoadedImageDatas))
        }

    }

    private func handleResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<ImageResult, NetworkError> {
        if let error = error { return .failure(.transportError(error)) }
        if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
            return .failure(.serverError(statusCode: response.statusCode))
        }
        guard let urlString = response?.url?.absoluteString else { return .failure(.noResponseUrl) }
        guard let data = data else { return .failure(.noData) }
        return .success((urlString, data))
    }

    private func sortLoadedImageDatas(_ notSortImageDatas: [ImageResult]) -> [Data] {
        notSortImageDatas.sorted { image1, image2 in
            findUrlIndex(by: image1.url) > findUrlIndex(by: image2.url)
        }
        .map { $0.data }
    }

    private func findUrlIndex(by urlString: String) -> Int {
        guard let index = imageUrls.firstIndex(of: urlString) else { return 0 }
        return index.distance(to: index)
    }

}
