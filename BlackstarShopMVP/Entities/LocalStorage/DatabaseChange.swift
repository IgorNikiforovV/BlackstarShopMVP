//
//  DatabaseChange.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.03.2022.
//

import RealmSwift

struct DatabaseChange<T: Object> where T: DomainConvertibleType {
    enum Status {
        case initial
        case update
    }

    var status: Status

    var initialResult: [T] = []

    var changeResults: [T] = []
    var insertions: [T] = []
    var modifications: [T] = []
    var deleteIndexes: [Int] = []
    var insertIndexes: [Int] = []
    var modifyIndexes: [Int] = []

    init(
        initialResult: Results<T>
    ) {
        status = .initial
        self.initialResult = Array(initialResult)
    }

    init(
        results: Results<T>,
        deleteIndexes: [Int],
        insertIndexes: [Int],
        modifyIndexes: [Int]
    ) {
        status = .update
        self.deleteIndexes = deleteIndexes
        self.insertIndexes = insertIndexes
        self.modifyIndexes = modifyIndexes

        self.insertions = insertIndexes.map { results.count > $0 ? results[$0] : nil }.compactMap { $0 }
        self.modifications = modifyIndexes.map { results.count > $0 ? results[$0] : nil }.compactMap { $0 }
        self.changeResults = Array(results)
    }
}

extension DatabaseChange: DomainConvertibleType {

    func asDomain() -> DomainDatabaseChange<T.DomainType> {
        DomainDatabaseChange(initialResult: initialResult.map { $0.asDomain() },
                             changeResults: changeResults.map { $0.asDomain() },
                             insertions: insertions.map { $0.asDomain() },
                             modifications: modifications.map { $0.asDomain() },
                             deleteIndexes: deleteIndexes,
                             insertIndexes: insertIndexes,
                             modifyIndexes: modifyIndexes)
    }

}
