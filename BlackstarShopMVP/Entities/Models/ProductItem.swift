//
//  ProductItem.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 07.02.2022.
//

import Foundation

struct ProductItem {
    let id: String
    let name: String
    let englishName: String
    let mainImage: String?
    let description: String?
    let productImages: [ProductImageItem]
    let offers: [ProductOfferItem]
    let selectedSizeIndex: Int?
    let price: String
    let sortOrder: String
    var preparedPrice: String {
        guard let intPrice = Float(price.trimmingCharacters(in: .whitespaces)) else { return "-" }
        return intPrice.currencyRUB
    }

    static func productItem(id: String, from productInfo: ProductInfo) -> ProductItem {
        .init(id: id,
              name: productInfo.name,
              englishName: productInfo.englishName,
              mainImage: productInfo.mainImage,
              description: productInfo.description,
              productImages: productInfo.productImages.map { ProductImageItem.productImageItem(from: $0) },
              offers: productInfo.offers.map { ProductOfferItem.productOfferItem(from: $0) },
              selectedSizeIndex: productInfo.offers.isEmpty ? nil : 0,
              price: productInfo.price,
              sortOrder: productInfo.sortOrder)
    }
}

struct ProductImageItem {
    let imageURL: String
    let sortOrder: String

    static func productImageItem(from imageInfo: ProductImageInfo) -> ProductImageItem {
        .init(imageURL: imageInfo.imageURL, sortOrder: imageInfo.sortOrder)
    }
}

struct ProductOfferItem {
    let size: String
    let quantity: String

    static func productOfferItem(from offerInfo: ProductOfferInfo) -> ProductOfferItem {
        .init(size: offerInfo.size, quantity: offerInfo.quantity)
    }
}
