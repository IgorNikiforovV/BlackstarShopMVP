//
//  String.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 17.02.2022.
//

import UIKit

extension String {

    func fromHTML(attributes: [String: [NSAttributedString.Key: Any]], commonAttribute: [NSAttributedString.Key: Any]) -> NSAttributedString? {
        let htmlCSSString = "<style>html *{font-family: '-apple-system'}</style>\(self)"
        guard let data = htmlCSSString.data(using: .utf8) else { return nil }
        guard let attributedString =
            try? NSMutableAttributedString(data: data,
                                           options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                                           ],
                                           documentAttributes: nil) else { return nil }
        let keys = attributes.keys
        attributedString.enumerateAttributes(
            in: NSRange(location: 0, length: attributedString.length),
            options: .longestEffectiveRangeNotRequired) { currentAttribute, range, _ in
                // swiftlint:disable force_cast
                let font: UIFont = currentAttribute[NSAttributedString.Key.font] as! UIFont
                // swiftlint:enable force_cast
                for key in keys {
                    if font.fontName.lowercased().range(of: key) != nil,
                       let attribute = attributes[key] {
                        attributedString.addAttributes(attribute, range: range)
                        return
                    }
                }
                attributedString.addAttributes(commonAttribute, range: range)
        }
        return attributedString
    }

}
