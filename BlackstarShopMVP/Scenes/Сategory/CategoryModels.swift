//
//  CategoryModels.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Category {

    enum FetchData {
        struct Request {
            enum RequestType {
                case getNewCategories
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewCategories(_ model: [CategoryCellModel])
                case presentError(_ error: String)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewCategories(_ viewModel: [CategoryCellVModel])
                case displayError(_ error: String)
            }
        }
    }

}

struct CategoryCellModel {
    let pictureUrl: String
    let titleText: String
    let iconUrl: String?
}

struct CategoryCellVModel {
    let picture: UIImage
    let title: NSAttributedString
    let icon: UIImage?
}
