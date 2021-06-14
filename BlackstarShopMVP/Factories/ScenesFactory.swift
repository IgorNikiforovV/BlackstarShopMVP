//
//  ScenesFactory.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 28.05.2021.
//

protocol ScenesFactory {
    static func makeCategoriesScene(_ subcategories: CategoryBox?) -> Presentable & CategoryDisplayLogic
}
