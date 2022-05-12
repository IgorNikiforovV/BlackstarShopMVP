//
//  DBBasketService.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 09.04.2022.
//

import Foundation

protocol DBBasketService {
    func observeBasketItemsUpdates(_ block: (() -> Void)?)
    func observeBasketItemsChanges(_ completion: @escaping (DomainDatabaseChange<BasketItem>) -> Void)
    func fetchBasketItems() -> [BasketItem]
    func saveBasketItem(item: BasketItem)
    func deleteBasketItem(item: BasketItem)
    func deleteAllBasketItems()
}

final class DBBasketServiceImpl {
    private(set) var databaseManager: DatabaseManagerProtocol

    init(databaseManager: DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
    }
}

extension DBBasketServiceImpl: DBBasketService {
    func observeBasketItemsUpdates(_ block: (() -> Void)?) {
        databaseManager.databaseContextNotification = block
    }

    func observeBasketItemsChanges(_ completion: @escaping (DomainDatabaseChange<BasketItem>) -> Void) {
        databaseManager.observeChanges(DBBasketItem.self) { result in
            switch result {
            case .success(let dbChange):
                completion(dbChange.asDomain())
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchBasketItems() -> [BasketItem] {
        databaseManager.fetch(DBBasketItem.self).map { $0.asDomain() }
    }

    func saveBasketItem(item: BasketItem) {
        do {
            try databaseManager.save(object: item.asRealm())
        } catch {
            print("Error saving \(item): \(error.localizedDescription)")
        }
    }

    func deleteBasketItem(item: BasketItem) {
        do {
            let predicate = NSPredicate(format: "id == %@", item.id)
            try databaseManager.delete(object: item.asRealm(), predicate: predicate)
        } catch {
            print("Error deleting \(item): \(error.localizedDescription)")
        }
    }

    func deleteAllBasketItems() {
        do {
            try databaseManager.deleteAll(DBBasketItem.self)
        } catch {
            print(error.localizedDescription)
        }
    }
}
