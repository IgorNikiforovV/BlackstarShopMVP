//
//  ProductSceneViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 30.01.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductSceneDisplayLogic: AnyObject {
    func updateImageSlider(response: ProductScene.StartupData.ViewModel)
    func updateProductName(response: ProductScene.StartupData.ViewModel)
    func updateProductDescription(response: ProductScene.StartupData.ViewModel)
    func updateProductPrice(response: ProductScene.StartupData.ViewModel)
}

class ProductSceneViewController: UIViewController {

    @IBOutlet private weak var sliderView: ImageHorizontalCollectionView!
    @IBOutlet private weak var contentContainerStackView: UIStackView!
    @IBOutlet private weak var imagesContainerView: UIView!

    var interactor: ProductSceneBusinessLogic?
    var router: (NSObjectProtocol & ProductSceneRoutingLogic)?

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

        interactor?.viewIsReady(request: ProductScene.StartupData.Request())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }

}

extension ProductSceneViewController {
    func setNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
}

extension ProductSceneViewController: ProductSceneDisplayLogic {
    func updateImageSlider(response: ProductScene.StartupData.ViewModel) {
        sliderView.configure(response.imageStringUrls)
    }

    func updateProductName(response: ProductScene.StartupData.ViewModel) {

    }

    func updateProductDescription(response: ProductScene.StartupData.ViewModel) {

    }

    func updateProductPrice(response: ProductScene.StartupData.ViewModel) {

    }
}

// MARK: Constants

private extension ProductSceneViewController {

    enum Const {

    }

}
