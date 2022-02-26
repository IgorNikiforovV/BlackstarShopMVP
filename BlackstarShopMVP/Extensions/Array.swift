//
//  Array.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 08.02.2022.
//

import Foundation

extension Array {

    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }

}
