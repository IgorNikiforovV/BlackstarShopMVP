//
//  BasketSceneViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 05.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol BasketSceneDisplayLogic: AnyObject {
    func displayData(viewModel: BasketScene.Model.ViewModel.ViewModelData)
}

class BasketSceneViewController: UIViewController, BasketSceneDisplayLogic {

    var interactor: BasketSceneBusinessLogic?
    var router: (NSObjectProtocol & BasketSceneRoutingLogic)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Routing

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func displayData(viewModel: BasketScene.Model.ViewModel.ViewModelData) {

    }

}
