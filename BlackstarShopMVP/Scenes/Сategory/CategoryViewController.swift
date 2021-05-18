//
//  CategoryViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CategoryDisplayLogic: AnyObject {
    func displayData(viewModel: Category.Model.ViewModel.ViewModelData)
}

class CategoryViewController: UIViewController, CategoryDisplayLogic {

    var interactor: CategoryBusinessLogic?
    var router: (NSObjectProtocol & CategoryRoutingLogic)?

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
        let interactor            = CategoryInteractor()
        let presenter             = CategoryPresenter()
        let router                = CategoryRouter()
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

    func displayData(viewModel: Category.Model.ViewModel.ViewModelData) {

    }

}
