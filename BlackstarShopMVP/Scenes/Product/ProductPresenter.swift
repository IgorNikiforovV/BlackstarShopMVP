//
//  ProductPresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductPresentationLogic {
  func presentData(response: Product.Model.Response.ResponseType)
}

class ProductPresenter: ProductPresentationLogic {
  weak var viewController: ProductDisplayLogic?
  
  func presentData(response: Product.Model.Response.ResponseType) {
  
  }
  
}
