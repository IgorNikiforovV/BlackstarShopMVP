//
//  CategoryPresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CategoryPresentationLogic {
    func prepareUISettings(response: Category.ConfigureUI.Response)
    func prepareContentData(response: Category.FetchData.Response.ResponseData)
    func prepareNavigationData(response: Category.NavigateToScene.Response.PrepareData)
}

class CategoryPresenter: CategoryPresentationLogic {

    weak var viewController: CategoryDisplayLogic?

    func prepareUISettings(response: Category.ConfigureUI.Response) {
        viewController?.configureUI(viewModel: .init(title: response.navBarTitle,
                                                     navigationBarTintColor: Const.navigationBarTintColor,
                                                     navigationTintColor: Const.navigationTintColor))
    }

    func prepareContentData(response: Category.FetchData.Response.ResponseData) {
        switch response {
        case .success(let cellModels):
            let categoryCellsVM = categoryCellsVM(from: cellModels)
            viewController?.displayData(viewModel: .displayNewCategories(categoryCellsVM))
        case .failure(let errorText):
            viewController?.displayData(viewModel: .displayError(errorText))
        }
    }

    func prepareNavigationData(response: Category.NavigateToScene.Response.PrepareData) {
        switch response {
        case .prepareDataToSubcategoriesScene(let categoryBox):
            guard categoryBox.stateScreen == .subcategories else { return }
            viewController?.navigateToOtherScene(viewModel: .routeSubcategories(categoryBox))
        case .prepareDataToProductsScene(let subcategoryId):
            viewController?.navigateToOtherScene(viewModel: .routeProducts(subcategoryId))
        }
    }

}

// MARK: Private methods

private extension CategoryPresenter {

    func categoryCellsVM(from models: [CategoryCellModel]) -> [CategoryCellVM] {
        models.map {
            .init(
                id: $0.id,
                picture: Const.url(from: $0.picture),
                title: Const.titleAttrebutedText(text: $0.title),
                icon: Const.url(from: $0.icon)
            )
        }
    }

}

extension CategoryPresenter {

    enum Const {

        // navigation bar
        static let navigationBarTintColor = R.color.colors.whiteColor()!
        static let navigationTintColor = R.color.colors.blackColor()!
        static let navigationBarTitleAttributes = [
            NSAttributedString.Key.foregroundColor: R.color.colors.blackColor(),
            NSAttributedString.Key.font: R.font.sfProTextSemibold(size: 17)!
        ]
        static func navigationBarAttrebutedText(text: String) -> NSAttributedString {
            NSAttributedString(string: text, attributes: titleAttributes)
        }

        // cell
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
            let urlText = "\(NetworkConst.baseUrl)\(text)"
            return URL(string: urlText)
        }

    }

}
