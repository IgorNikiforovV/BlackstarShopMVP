//
//  ProductInteractor.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductBusinessLogic {
  func makeRequest(request: Product.Model.Request.RequestType)
}

class ProductInteractor: ProductBusinessLogic {

  var presenter: ProductPresentationLogic?
  var service: ProductService?
  
  func makeRequest(request: Product.Model.Request.RequestType) {
    if service == nil {
      service = ProductService()
    }
  }
  
}
