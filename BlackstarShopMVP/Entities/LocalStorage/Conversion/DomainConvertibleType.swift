//
//  DomainConvertibleType.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 03.04.2022.
//

protocol DomainConvertibleType {
    associatedtype DomainType

    func asDomain() -> DomainType
}
