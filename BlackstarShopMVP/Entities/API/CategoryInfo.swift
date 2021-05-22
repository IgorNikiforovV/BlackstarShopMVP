//
//  CategoryInfo.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 20.05.2021.
//

struct CategoryInfo: Decodable {
    let name: String
    let sortOrder: Int
    let image: String
    let iconImage: String?
    let iconImageActive: String?
    let subcategories: [SubcategoryInfo]
}

// since the field sortOrder can be both a string or a number, we need to write our own decoder

extension CategoryInfo {

    enum CodingKeys: String, CodingKey {
        case name
        case sortOrder
        case image
        case iconImage
        case iconImageActive
        case subcategories
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        if let sortOrder = try? values.decode(Int.self, forKey: .sortOrder) {
            self.sortOrder = sortOrder
        } else {
            sortOrder = Int((try? values.decode(String.self, forKey: .sortOrder)) ?? "0") ?? 100
        }
        image = try values.decode(String.self, forKey: .image)
        iconImage = try? values.decode(String.self, forKey: .iconImage)
        iconImageActive = try? values.decode(String.self, forKey: .iconImageActive)
        subcategories = try values.decode([SubcategoryInfo].self, forKey: .subcategories)
    }

}
