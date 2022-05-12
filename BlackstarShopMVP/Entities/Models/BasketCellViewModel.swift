//
//  BasketCellViewModel.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 21.04.2022.
//

import Foundation

struct BasketCellViewModel: BasketCellInput {
    let imageUrl: String?
    let name: String
    let size: String?
    let color: String
    let price: String
}
