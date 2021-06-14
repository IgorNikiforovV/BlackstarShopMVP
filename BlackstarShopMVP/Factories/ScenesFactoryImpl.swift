//
//  ScenesFactoryImpl.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 28.05.2021.
//

enum ScenesFactoryImpl: ScenesFactory {

    static func makeCategoriesScene(_ subcategories: CategoryBox?) -> Presentable & CategoryDisplayLogic {
        let viewController        = CategoryViewController()
        let interactor            = CategoryInteractor()
        let presenter             = CategoryPresenter()
        let router                = CategoryRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        if let subcategories = subcategories {
            interactor.setSubcategories(model: subcategories)
        }
        return viewController
    }


}
