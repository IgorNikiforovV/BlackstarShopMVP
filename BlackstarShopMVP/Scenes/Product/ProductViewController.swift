//
//  ProductViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 22.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProductDisplayLogic: AnyObject {
    func configureUI(viewModel: Category.ViewModel.UIConfiguration)
    func updateUI(viewModel: Category.ViewModel.UIUpdating)
    func navigateToScene(viewModel: Category.ViewModel.Routing)
}

class ProductViewController: UIViewController, ProductDisplayLogic {

    var interactor: ProductBusinessLogic?
    var router: (NSObjectProtocol & ProductRoutingLogic)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Routing

    // MARK: @IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor?.handleAction(request: .viewIsReady)
        configureCollectionView() 
    }

    func configureUI(viewModel: Category.ViewModel.UIConfiguration) {

    }

    func updateUI(viewModel: Category.ViewModel.UIUpdating) {

    }

    func navigateToScene(viewModel: Category.ViewModel.Routing) {

    }

}

extension ProductViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ProductViewController.models.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath)
        if let cell = cell as? ProductCell {
            cell.configure(ProductViewController.models[indexPath.item])
        }
        return cell
    }


}

// MARK: Private methods

private extension ProductViewController {

    func configureCollectionView() {
        collectionView.register(
            UINib(nibName: ProductCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: ProductCell.identifier
        )
    }

}

// MARK: Mock data

extension ProductViewController {
    static let models: [ProductCellInput] = [
        ProductCellModel(id: 1,
                         title: "Куртка 1452",
                         description: "Специальная коллекция",
                         picture: "https://blackstarshop.ru/image/cache/catalog/p/8003/9t0a1842-h_1_630x840.jpg",
                         price: "2500 Р"),
        ProductCellModel(id: 1,
                         title: "Жакет 5622",
                         description: "Специальная коллекция",
                         picture: "https://blackstarshop.ru/image/cache/catalog/p/7988/9t0a3615-h_1_630x840.jpg",
                         price: "4500 Р"),
        ProductCellModel(id: 1,
                         title: "Ветровка 885",
                         description: "Специальная коллекция",
                         picture: "https://blackstarshop.ru/image/cache/catalog/p/8003/9t0a1842-h_1_630x840.jpg",
                         price: "3670 Р"),
        ProductCellModel(id: 1,
                         title: "Штаны 2536",
                         description: "Специальная коллекция",
                         picture: "https://blackstarshop.ru/image/cache/catalog/p/8020/9t0a8675-h_1_630x840.jpg",
                         price: "1243 Р"),
        ProductCellModel(id: 1,
                         title: "Носки 1111",
                         description: "Специальная коллекция",
                         picture: "https://blackstarshop.ru/image/cache/catalog/p/7992/9t0a1636-h_1_630x840.jpg",
                         price: "1000 Р"),
        ProductCellModel(id: 1,
                         title: "Перчатки 34343 ",
                         description: "Специальная коллекция",
                         picture: "https://blackstarshop.ru/image/cache/catalog/p/8003/9t0a1842-h_1_630x840.jpg",
                         price: "3400 Р")
    ]
}
