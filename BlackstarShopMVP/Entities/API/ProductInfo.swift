//
//  ProductInfo.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 27.06.2021.
//

struct ProductInfo: Decodable {
    let name: String
    let englishName: String
    let sortOrder: String
    let description: String?
    let colorName: String
    let colorImageURL: String?
    let mainImage: String?
    let productImages: [ProductImageInfo]
    let offers: [ProductOfferInfo]
    let price: String
}

struct ProductImageInfo: Decodable {
    let imageURL: String
    let sortOrder: String
}

struct ProductOfferInfo: Decodable {
    let size: String
    let productOfferID: String
    let quantity: String
}
