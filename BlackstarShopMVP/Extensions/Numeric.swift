//
//  Numeric.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 15.02.2022.
//

import Foundation

extension Numeric {

    var currencyRUB: String { return Formatter.currencyRUB.string(for: self) ?? "" }

}
