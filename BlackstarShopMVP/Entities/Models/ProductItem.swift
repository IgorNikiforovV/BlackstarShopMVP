//
//  ProductItem.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 07.02.2022.
//

struct ProductItem {
    let id: String
    let name: String
    let englishName: String
    let mainImage: String?
    let description: String?
    let productImages: [ProductImageItem]
    let price: String
    let sortOrder: String

    static func productItem(id: String, from: ProductInfo) -> ProductItem {
        .init(id: id,
              name: from.name,
              englishName: from.englishName,
              mainImage: from.mainImage,
              description: from.description,
              productImages: from.productImages.map { ProductImageItem.productImageItem(from: $0) },
              price: from.price,
              sortOrder: from.sortOrder)
    }
}

struct ProductImageItem {
    let imageURL: String
    let sortOrder: String

    static func productImageItem(from: ProductImageInfo) -> ProductImageItem {
        .init(imageURL: from.imageURL, sortOrder: from.sortOrder)
    }
}
