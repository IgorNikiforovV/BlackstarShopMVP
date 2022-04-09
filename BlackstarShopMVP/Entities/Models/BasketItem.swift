//
//  BasketItem.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 09.04.2022.
//

import Foundation

struct BasketItem {
    let id: String
    let productId: String
    let name: String
    let imagePath: String?
    let colorName: String
    let size: Int?
    let price: String
}

extension BasketItem {
    static func basketItem(from productItem: ProductItem) -> BasketItem {
        BasketItem(id: UUID().uuidString,
                   productId: productItem.id,
                   name: productItem.name,
                   imagePath: productItem.mainImage,
                   colorName: productItem.colorName,
                   size: productItem.selectedSizeIndex,
                   price: productItem.price)
    }
}
