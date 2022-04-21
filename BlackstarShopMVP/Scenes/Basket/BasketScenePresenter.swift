//
//  BasketScenePresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 05.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol BasketScenePresentationLogic {
    func presentData(with response: BasketScene.StartupData.Response)
}

class BasketScenePresenter: BasketScenePresentationLogic {

    weak var viewController: BasketSceneDisplayLogic?

    func presentData(with response: BasketScene.StartupData.Response) {
        let basketCells = basketCellViewModels(from: response.basketItems)
        let totalPrice = sumPrices(from: response.basketItems)
        let viewModel = BasketScene.StartupData.ViewModel(basketCells: basketCells, totalPrice: totalPrice)
        viewController?.showBasketProducts(with: viewModel)
    }

}

// MARK: private methods

private extension BasketScenePresenter {

    func preparePrice(rowPrice: String) -> String {
        guard let intPrice = Float(rowPrice.trimmingCharacters(in: .whitespaces)) else { return "-" }
        return intPrice.currencyRUB
    }

    func imageUrl(from imagePathString: String?) -> URL? {
        guard let imagePathString = imagePathString else { return nil }
        return URL(string: imagePathString)
    }

    func basketCellViewModels(from basketItems: [BasketItem]) -> [BasketCellInput] {
        basketItems.map {
            BasketCellViewModel(imageUrl: imageUrl(from: $0.imagePath),
                                name: $0.name,
                                size: $0.size,
                                color: $0.colorName,
                                price: preparePrice(rowPrice: $0.price))
        }
    }

    func sumPrices(from basketItems: [BasketItem]) -> String {
        var totalSum: Float = 0
        for item in basketItems {
            if let priceItem = Float(item.price.trimmingCharacters(in: .whitespaces)) {
                totalSum += priceItem
            } else {
                return "Ошибка"
            }
        }
        return totalSum.currencyRUB
    }

}
