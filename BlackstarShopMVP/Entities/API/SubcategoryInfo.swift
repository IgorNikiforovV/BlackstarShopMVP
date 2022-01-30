//
//  SubcategoryInfo.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.05.2021.
//

enum SubcategoryTypeInfo: String, Codable {
    case category = "Category"
    case collection = "Collection"
    case unknown

    init(type: String) {
        self = SubcategoryTypeInfo(rawValue: type) ?? .unknown
    }
}

struct SubcategoryInfo: Decodable {
    let id: Int
    let sortOrder: Int
    let type: SubcategoryTypeInfo
    let iconImage: String?
    let name: String?
}

// since the field can be both a string or a number, we need to write our own decoder

extension SubcategoryInfo {

    enum CodingKeys: String, CodingKey {
        case id
        case sortOrder
        case type
        case iconImage
        case name
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        if let id = try? values.decode(Int.self, forKey: .id) {
            self.id = id
        } else {
            id = Int((try? values.decode(String.self, forKey: .id)) ?? "0") ?? 0
        }
        if let sortOrder = try? values.decode(Int.self, forKey: .sortOrder) {
            self.sortOrder = sortOrder
        } else {
            sortOrder = Int((try? values.decode(String.self, forKey: .sortOrder)) ?? "0") ?? 100
        }
        let type = try values.decode(String.self, forKey: .type)
        self.type = SubcategoryTypeInfo(type: type)
        iconImage = try values.decode(String.self, forKey: .iconImage)
        name = try values.decode(String.self, forKey: .name)
    }


}
