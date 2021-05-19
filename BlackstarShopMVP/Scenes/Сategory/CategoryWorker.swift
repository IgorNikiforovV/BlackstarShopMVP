//
//  CategoryWorker.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class CategoryService {
    func fetchCategories() -> [CategoryCellModel] {
        [CategoryCellModel(pictureUrl: "image/catalog/im2017/3.png",
                           titleText: "Мужская",
                           iconUrl: "https://blackstarshop.ru/image/catalog/style/modile/man_cat_active_s.png"),
         CategoryCellModel(pictureUrl: "https://blackstarshop.ru/image/catalog/im2017/2.png",
                           titleText: "Детская",
                           iconUrl: "https://blackstarshop.ru/image/catalog/style/modile/child_cat_active_s.png"),
         CategoryCellModel(pictureUrl: "image/catalog/im2017/1.png",
                           titleText: "Женская",
                           iconUrl: "image/catalog/style/modile/girl_cat_active_s.png")]
    }
}
