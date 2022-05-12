//
//  RealmRepresentable.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 03.04.2022.
//

protocol RealmRepresentable {
    associatedtype RealmType: DomainConvertibleType

    func asRealm() -> RealmType
}
