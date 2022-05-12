//
//  BasketDB.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 09.04.2022.
//

import RealmSwift

class DBBasketItem: Object {
    @objc dynamic var id = ""
    @objc dynamic var productId = ""
    @objc dynamic var name: String = ""
    @objc dynamic var imagePath: String?
    @objc dynamic var colorName: String = ""
    @objc dynamic var size: String?
    @objc dynamic var price: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - RealmRepresentable

extension BasketItem: RealmRepresentable {
    func asRealm() -> DBBasketItem {
        DBBasketItem.build {
            $0.id = id
            $0.productId = productId
            $0.name = name
            $0.imagePath = imagePath
            $0.colorName = colorName
            $0.size = size
            $0.price = price
        }
    }
}

// MARK: - DomainConvertibleType

extension DBBasketItem: DomainConvertibleType {
    func asDomain() -> BasketItem {
        BasketItem(id: id,
                   productId: productId,
                   name: name,
                   imagePath: imagePath,
                   colorName: colorName,
                   size: size,
                   price: price)
    }
}
