//
//  Formatter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 15.02.2022.
//

import Foundation

extension Formatter {

    static let currencyRUB: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter
    }()

}
