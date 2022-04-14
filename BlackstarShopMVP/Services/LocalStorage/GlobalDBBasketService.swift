//
//  GlobalDBBasketService.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 12.04.2022.
//

import Foundation

protocol GlobalBasketStorageService {
    var basketItems: [BasketItem] { get }
    func addObserver(object: BasketItemsSubscribable)
    func addBasketItem(newBasketItem: BasketItem)
    func deleteBasketItem(basketItem: BasketItem)
}

protocol BasketItemsSubscribable {
    func basketItemsDidChange(newBasketItems: [BasketItem])
}

class GlobalBasketStorageServiceImpl {
    static let shared = GlobalBasketStorageServiceImpl()

    private let dbBasketService: DBBasketService = DBBasketServiceImpl(databaseManager: DatabaseManager())
    private var observers = NSPointerArray(options: .weakMemory)

    private(set) var basketItems = [BasketItem]()

    private init() {
        dbBasketService.observeBasketItemsChanges { [weak self] change in
            self?.updateBasketItems(from: change)
        }
    }

    private func updateBasketItems(from change: DomainDatabaseChange<BasketItem>) {
        basketItems = change.initialResult.isEmpty ? change.changeResults : change.initialResult
        observers.allObjects.forEach {
            ($0 as? BasketItemsSubscribable)?.basketItemsDidChange(newBasketItems: basketItems)
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
