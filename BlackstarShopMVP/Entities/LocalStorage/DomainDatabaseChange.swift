//
//  DomainDatabaseChange.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 03.04.2022.
//

struct DomainDatabaseChange<T> {
    let insertions: [T]
    let modifications: [T]
    let deleteIndexes: [Int]
    let insertIndexes: [Int]
    let modifyIndexes: [Int]
}
