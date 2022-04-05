import RealmSwift

// MARK: - RealmDatabaseAccessible

protocol RealmDatabaseAccessible {
    var realm: Realm { get }

    // Thread safe realm instance
    func safeRealm() -> Realm
}

extension RealmDatabaseAccessible {

    func safeRealm() -> Realm {
        let configuration = realm.configuration
        // swiftlint:disable force_try
        return try! Realm(configuration: configuration)
        // swiftlint:enable force_try
    }

}

// MARK: - DatabaseManagerProtocol

protocol DatabaseManagerProtocol {
    var databaseContextNotification: (() -> Void)? { get set }
    func observeChanges<T: Object>(_ model: T.Type, _ completion: @escaping (Swift.Result<DatabaseChange<T>, Error>) -> Void)

    func save<T: Object>(object: T, update: Realm.UpdatePolicy) throws
    func save<T: Object>(objects: [T], update: Realm.UpdatePolicy) throws
    func save(withoutNotifying: Bool, _ block: () -> Void) throws

    func delete<T: Object>(object: T, withoutNotifying: Bool) throws
    func delete<T: Object>(objects: [T]) throws
    func deleteAll<T: Object>(_ model: T.Type, withoutNotifying: Bool) throws

    func fetch<T: Object>(_ model: T.Type, predicate: NSPredicate?) -> [T]

    func clearAllData()
}

extension DatabaseManagerProtocol {

    func save<T: Object>(object: T, update: Realm.UpdatePolicy = .all) throws {
        return try save(object: object, update: update)
    }

    func save<T: Object>(objects: [T], update: Realm.UpdatePolicy = .all) throws {
        return try save(objects: objects, update: update)
    }

    func save(withoutNotifying: Bool = false, _ block: () -> Void) throws {
        return try save(withoutNotifying: withoutNotifying, block)
    }

    func delete<T: Object>(object: T, withoutNotifying: Bool = false) throws {
        return try delete(object: object, withoutNotifying: withoutNotifying)
    }

    func deleteAll<T: Object>(_ model: T.Type, withoutNotifying: Bool = false) throws {
        return try deleteAll(model, withoutNotifying: withoutNotifying)
    }

    func fetch<T: Object>(_ model: T.Type, predicate: NSPredicate? = nil) -> [T] {
        return fetch(model, predicate: predicate)
    }

}

enum ConfigurationType {
    case persistent(String?)
    case inMemory(String)
}

class DatabaseManager: RealmDatabaseAccessible {

    lazy var realm: Realm = {

        var configuration = Realm.Configuration.defaultConfiguration

        let newSchemaVersion: UInt64 = 1
        let migrationBlock: MigrationBlock = { _, oldSchemaVersion in
            if oldSchemaVersion < newSchemaVersion {}
        }

        switch self.configuration {
        case .persistent(let fileUrlString):
            if let fileUrlString = fileUrlString {
                configuration = Realm.Configuration(fileURL: URL(string: fileUrlString),
                                                    schemaVersion: newSchemaVersion,
                                                    migrationBlock: migrationBlock)
            } else {
                configuration = Realm.Configuration(schemaVersion: newSchemaVersion,
                                                    migrationBlock: migrationBlock)
            }
        case .inMemory(let identifier):
            configuration = Realm.Configuration(inMemoryIdentifier: identifier)
        }

        // swiftlint:disable force_try
        let realm = try! Realm(configuration: configuration)
        // swiftlint:enable force_try
        notificationToken = realm.observe({ [weak self] _, _ in
            self?.contextNotification?()
        })
        return realm
    }()

    private var notificationToken: NotificationToken?
    private var collectionsNotificationTokens = [NotificationToken]()

    private let configuration: ConfigurationType

    required init(configuration: ConfigurationType = .persistent(nil)) {
        self.configuration = configuration
    }

    var contextNotification: (() -> Void)?

    deinit {
        notificationToken?.invalidate()
        collectionsNotificationTokens.forEach { $0.invalidate() }
    }

}

// MARK: - DatabaseManagerProtocol methods

extension DatabaseManager: DatabaseManagerProtocol {

    var databaseContextNotification: (() -> Void)? {
        get {
            return self.contextNotification
        }
        set {
            self.contextNotification = newValue
        }
    }

    func observeChanges<T: Object>(_ model: T.Type, _ completion: @escaping (Swift.Result<DatabaseChange<T>, Error>) -> Void) {
        let realm = self.safeRealm()
        let objects = realm.objects(model)

        let collectionsNotificationToken = objects.observe { changes in
            var notificationModel: DatabaseChange<T>

            switch changes {
            case .initial(let results):
                notificationModel = DatabaseChange(initialResult: results)
                completion(.success(notificationModel))
            // swiftlint:disable pattern_matching_keywords
            case .update(let results,
                         let deletions,
                         let insertions,
                         let modifications):
            // swiftlint:enable pattern_matching_keywords
                notificationModel = DatabaseChange(results: results,
                                                   deleteIndexes: deletions,
                                                   insertIndexes: insertions,
                                                   modifyIndexes: modifications)
                completion(.success(notificationModel))
            case .error(let error):
                completion(.failure(error))
            }

        }
        collectionsNotificationTokens.append(collectionsNotificationToken)
    }

    func save<T: Object>(object: T, update: Realm.UpdatePolicy = .all) throws {
        let realm = self.safeRealm()
        realm.beginWrite()
        realm.add(object, update: update)
        return try realm.commitWrite()
    }

    func save<T: Object>(objects: [T], update: Realm.UpdatePolicy = .all) throws {
        let realm = self.safeRealm()
        realm.beginWrite()
        realm.add(objects, update: update)
        return try realm.commitWrite()
    }

    func save(withoutNotifying: Bool = false, _ block: () -> Void) throws {
        let realm = self.safeRealm()
        if withoutNotifying {
            try realm.write(withoutNotifying: collectionsNotificationTokens) {
                block()
            }
        } else {
            try realm.write {
                block()
            }
        }
    }

    func delete<T: Object>(object: T, withoutNotifying: Bool = false) throws {
        let realm = self.safeRealm()
        if withoutNotifying {
            try realm.write(withoutNotifying: collectionsNotificationTokens) {
                realm.delete(object)
            }
        } else {
            try realm.write {
                realm.delete(object)
            }
        }
    }

    func delete<T: Object>(objects: [T]) throws {
        let realm = self.safeRealm()
        realm.beginWrite()
        realm.delete(objects)
        return try realm.commitWrite()
    }

    func deleteAll<T: Object>(_ model: T.Type, withoutNotifying: Bool = false) throws {
        let realm = self.safeRealm()
        let objects = realm.objects(model)
        if withoutNotifying {
            try realm.write(withoutNotifying: collectionsNotificationTokens) {
                objects.forEach { realm.delete($0) }
            }
        } else {
            try realm.write {
                objects.forEach { realm.delete($0) }
            }
        }
    }

    func fetch<T: Object>(_ model: T.Type, predicate: NSPredicate? = nil) -> [T] {
        let realm = self.safeRealm()
        var objects = realm.objects(model)

        if let predicate = predicate {
            objects = objects.filter(predicate)
        }

        return objects.compactMap { $0 }
    }

    func clearAllData() {
        do {
            let realm = self.safeRealm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {}
    }

}
