//
//  ProductInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductBusinessLogic {
    func handleAction(request: Category.Request.ActionHandling)
}

protocol ProductInteractorInput {
    var productId: Int? { get set }
}

class ProductInteractor: ProductBusinessLogic, ProductInteractorInput {

    var presenter: ProductPresentationLogic?
    var service: ProductService?

    // MARK: ProductInteractorInput

    var productId: Int?

    // MARK: ProductBusinessLogic

    func handleAction(request: Category.Request.ActionHandling) {
        switch request {
        case .viewIsReady:
            print("viewIsReady")
        case .cellTapped(_):
            print("cellTapped")
        case .didPullToRefresh:
            print("didPullToRefresh")
        }
    }

}
