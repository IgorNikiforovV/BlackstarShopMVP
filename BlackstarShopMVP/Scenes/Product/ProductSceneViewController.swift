//
//  ProductSceneViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 30.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductSceneDisplayLogic: AnyObject {
    func displayData(viewModel: ProductScene.Model.ViewModel.ViewModelData)
}

class ProductSceneViewController: UIViewController, ProductSceneDisplayLogic {

    var interactor: ProductSceneBusinessLogic?
    var router: (NSObjectProtocol & ProductSceneRoutingLogic)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController        = self
        let interactor            = ProductSceneInteractor()
        let presenter             = ProductScenePresenter()
        let router                = ProductSceneRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }

    // MARK: Routing



    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func displayData(viewModel: ProductScene.Model.ViewModel.ViewModelData) {

    }

}
