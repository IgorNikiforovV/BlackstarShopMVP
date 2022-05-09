//
//  ProductScenePresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 30.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ProductScenePresentationLogic {
    func presentData(with response: ProductScene.StartupData.Response)
    func prepareSizesSheetData(with response: ProductScene.AddBasketTrapping.Response)
    func changeBasketBage(with response: ProductScene.BasketBageChanging.Response)
}

class ProductScenePresenter: ProductScenePresentationLogic {

    weak var viewController: ProductSceneDisplayLogic?

    func presentData(with response: ProductScene.StartupData.Response) {
        guard let product = response.product else { return }

        // TODO не забыть переделать сортировку в числовой формат
        let imageUrls = product.productImages
            .sorted(by: { image1, image2 in image1.sortOrder > image2.sortOrder })
            .compactMap { URL(string: "\(NetworkConst.baseUrl)\($0.imageURL)") }

        let viewModel = ProductScene.StartupData.ViewModel(imageStringUrls: imageUrls,
                                                           productName: product.name,
                                                           price: product.preparedPrice,
                                                           description: product.description)

        viewController?.updateData(with: viewModel)
    }

    func prepareSizesSheetData(with response: ProductScene.AddBasketTrapping.Response) {
        viewController?.showSizesSheet(with: ProductScene.AddBasketTrapping.ViewModel(sheetActions: response.sheetActions))
    }

    func changeBasketBage(with response: ProductScene.BasketBageChanging.Response) {
        viewController?.changeBasketBage(with: ProductScene.BasketBageChanging.ViewModel(count: response.count))
    }
}
