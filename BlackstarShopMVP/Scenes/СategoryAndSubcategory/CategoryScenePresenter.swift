//
//  CategoryScenePresenter.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CategoryScenePresentationLogic {
    func prepareUIConfigurationData(response: CategorySceneModels.Response.UIConfiguration)
    func prepareUIUpdatingData(response: CategorySceneModels.Response.UIUpdating)
    func prepareNavigationData(response: CategorySceneModels.Response.Routing)
}

class CategoryScenePresenter: CategoryScenePresentationLogic {

    weak var viewController: CategorySceneDisplayLogic?

    // MARK: - CategoryScenePresentationLogic -

    func prepareUIConfigurationData(response: CategorySceneModels.Response.UIConfiguration) {
        switch response {
        case .navBar(let title):
            let navBarVM = DisplayedNavBar(
                title: title,
                navigationBarTintColor: Const.navigationBarTintColor,
                navigationTintColor: Const.navigationTintColor
            )
            viewController?.configureUI(viewModel: .navBarConfiguration(navBarVM))
        case .refreshControl:
            viewController?.configureUI(viewModel: .refreshControl)
        }
    }

    func prepareUIUpdatingData(response: CategorySceneModels.Response.UIUpdating) {
        switch response {
        case .refreshControlHidding(let isHidden):
            viewController?.updateUI(viewModel: .refreshControlHidding(isHidden))
        case .tableViewDataReloading(let cellModels):
            let categoryCellsVM = categoryCellsVM(from: cellModels)
            viewController?.updateUI(viewModel: .tableViewDataReloading(categoryCellsVM))
        case .tableViewFailureReloading(let errorText):
            viewController?.updateUI(viewModel: .tableViewErrorReloading(errorText))
        }
    }

    func prepareNavigationData(response: CategorySceneModels.Response.Routing) {
        switch response {
        case .subcategoriesScene(let categoryBox):
            guard categoryBox.stateScreen == .subcategories else { return }
            viewController?.navigateToScene(viewModel: .subcategoriesScene(categoryBox))
        case .productsScene(let subcategoryId):
            viewController?.navigateToScene(viewModel: .productsScene(subcategoryId))
        }
    }

}

// MARK: Private methods

private extension CategoryScenePresenter {

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

extension CategoryScenePresenter {

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
