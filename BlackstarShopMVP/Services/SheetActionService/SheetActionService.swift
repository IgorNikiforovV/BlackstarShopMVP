//
//  SheetActionService.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 20.02.2022.
//

import Foundation

enum SheetActionService {
    static func sheetSizeActions(
        from sizesAndActions: [(size: ProductOfferItem, action: () -> Void)],
        and selectedIndex: Int,
        with textStyle: [NSAttributedString.Key: Any]
    ) -> [ShadowSheetAction] {
        sizesAndActions.enumerated().map {
            let attributedText = NSAttributedString(string: "\($0.element.size.size) (\($0.element.size.quantity))", attributes: textStyle)
            return .init(attributedTitle: attributedText,
                         leftImages: [R.image.common.measure()!],
                         rightImages: [],
                         centerImages: [],
                         selected: $0.offset == selectedIndex,
                         completion: $0.element.action)
        }
    }
}
