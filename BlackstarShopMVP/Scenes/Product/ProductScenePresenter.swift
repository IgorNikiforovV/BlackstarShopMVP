//
//  ProductScenePresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 30.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ProductScenePresentationLogic {
    func presentData(response: ProductScene.StartupData.Response)
}

class ProductScenePresenter: ProductScenePresentationLogic {
    weak var viewController: ProductSceneDisplayLogic?

    func presentData(response: ProductScene.StartupData.Response) {
        guard let product = response.product else { return }

        let imageUrls = product.productImages
            .sorted(by: { image1, image2 in image1.sortOrder > image2.sortOrder }) // не забыть веревести в числовой формат
            .compactMap { URL(string: "\(NetworkConst.baseUrl)\($0.imageURL)") }

        imageUrls.forEach { print($0.absoluteString) }

        let response = ProductScene.StartupData.ViewModel(imageStringUrls: imageUrls,
                                                          productName: product.name,
                                                          price: product.price,
                                                          description: product.description)

        viewController?.updateImageSlider(response: response)
        viewController?.updateProductName(response: response)
        viewController?.updateProductPrice(response: response)
    }

}
