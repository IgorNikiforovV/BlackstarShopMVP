//
//  DBBasketService.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 09.04.2022.
//

protocol DBBasketService {
    func observeBasketItemsUpdates(_ block: (() -> Void)?)
    func observeBasketItemsChanges(_ completion: @escaping (DomainDatabaseChange<BasketItem>) -> Void)
    func fetchBasketItems() -> [BasketItem]
    func saveBasketItem(item: BasketItem)
    func deleteBasketItem(item: BasketItem)
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
            try databaseManager.delete(object: item.asRealm())
        } catch {
            print("Error deleting \(item): \(error.localizedDescription)")
        }
    }
}
