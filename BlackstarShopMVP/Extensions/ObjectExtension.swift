//
//  ObjectExtension.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 09.04.2022.
//

import RealmSwift

extension Object {

    static func build<O: Object>(_ build: (O) -> Void) -> O {
        let object = O()
        build(object)
        return object
    }

}
