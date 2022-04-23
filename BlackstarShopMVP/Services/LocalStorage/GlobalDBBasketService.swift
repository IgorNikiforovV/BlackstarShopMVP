//
//  GlobalDBBasketService.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 12.04.2022.
//

import Foundation

protocol GlobalBasketStorageService {
    var basketItemsChange: DomainDatabaseChange<BasketItem>? { get }
    func addObserver(object: BasketItemsSubscribable)
    func addBasketItem(newBasketItem: BasketItem)
    func deleteBasketItem(basketItem: BasketItem)
}

protocol BasketItemsSubscribable {
    func basketItemsDidChange(basketItemsChange: DomainDatabaseChange<BasketItem>)
}

class GlobalBasketStorageServiceImpl {
    static let shared = GlobalBasketStorageServiceImpl()

    private let dbBasketService: DBBasketService = DBBasketServiceImpl(databaseManager: DatabaseManager())
    private var observers = NSPointerArray(options: .weakMemory)

    private(set) var basketItemsChange: DomainDatabaseChange<BasketItem>?

    private init() {
        dbBasketService.observeBasketItemsChanges { [weak self] change in
            self?.updateBasketItems(from: change)
        }
    }

    private func updateBasketItems(from change: DomainDatabaseChange<BasketItem>) {
        basketItemsChange = change
        observers.allObjects.forEach {
            ($0 as? BasketItemsSubscribable)?.basketItemsDidChange(basketItemsChange: change)
        }
    }
}

// MARK: GlobalBasketStorageService

extension GlobalBasketStorageServiceImpl: GlobalBasketStorageService {
    func addObserver(object: BasketItemsSubscribable) {
        observers.addPointer(Unmanaged.passUnretained(object as AnyObject).toOpaque())
    }

    func addBasketItem(newBasketItem: BasketItem) {
        dbBasketService.saveBasketItem(item: newBasketItem)
    }

    func deleteBasketItem(basketItem: BasketItem) {
        dbBasketService.deleteBasketItem(item: basketItem)
    }
}
