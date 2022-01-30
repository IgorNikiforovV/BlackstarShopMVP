//
//  ScenesFactoryImpl.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 28.05.2021.
//

enum ScenesFactoryImpl: ScenesFactory {

    static func makeCategoriesScene(_ subcategories: CategoryBox?) -> Presentable & CategorySceneDisplayLogic {
        let viewController        = CategorySceneViewController()
        let interactor            = CategorySceneInteractor()
        let presenter             = CategoryScenePresenter()
        let router                = CategorySceneRouter()
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

    static func makeProductListScene(_ subcategoryId: String) -> Presentable & ProductListSceneDisplayLogic {
        let viewController        = ProductListSceneViewController()
        let interactor            = ProductListSceneInteractor()
        let presenter             = ProductListScenePresenter()
        let router                = ProductListSceneRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
        interactor.subcategoryId = subcategoryId

        return viewController
    }


}
