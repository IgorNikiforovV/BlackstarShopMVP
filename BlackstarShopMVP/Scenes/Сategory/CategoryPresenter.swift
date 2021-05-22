//
//  CategoryPresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CategoryPresentationLogic {
    func presentData(response: Category.FetchData.Response.ResponseType)
}

class CategoryPresenter: CategoryPresentationLogic {
    weak var viewController: CategoryDisplayLogic?

    func presentData(response: Category.FetchData.Response.ResponseType) {
        switch response {
        case .presentNewCategories(let categoriesResponse):
            let categories = categoriesResponse.compactMap { $0.value }
            let viewModels = categories.map {
                CategoryCellVModel(
                    picture: Const.url(from: $0.image),
                    title: Const.titleAttrebutedText(text: $0.name),
                    icon: Const.url(from: $0.iconImage)
                )
            }
            viewController?.displayData(viewModel: .displayNewCategories(viewModels))
        case .presentError(let error):
            viewController?.displayData(viewModel: .displayError(error))
        }
    }

}

extension CategoryPresenter {

    enum Const {

        static func titleAttrebutedText(text: String) -> NSAttributedString {
            NSAttributedString(string: text, attributes: titleAttributes)
        }

        static let titleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: R.color.colors.blackColor()!,
            NSAttributedString.Key.font: R.font.sfProDisplayMedium(size: 16)!,
            NSAttributedString.Key.kern: 0.19
        ]

        static func url(from text: String?) -> URL? {
            guard let text = text else { return nil }
            return URL(string: text)
        }

    }

}
