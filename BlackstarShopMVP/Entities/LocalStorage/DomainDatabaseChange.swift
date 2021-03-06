//
//  DomainDatabaseChange.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 03.04.2022.
//

struct DomainDatabaseChange<T> {
    let initialResult: [T]
    let changeResults: [T]
    let insertions: [T]
    let modifications: [T]
    let deleteIndexes: [Int]
    let insertIndexes: [Int]
    let modifyIndexes: [Int]
    var result: [T] {
        initialResult.isEmpty ? changeResults : initialResult
    }
}
