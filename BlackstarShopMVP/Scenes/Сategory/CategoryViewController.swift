//
//  CategoryViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CategoryDisplayLogic: AnyObject {
    func configureUI(viewModel: Category.ConfigureUI.ViewModel.DisplayedNavBar)
    func displayData(viewModel: Category.FetchData.ViewModel.ViewModelData)
    func navigateToOtherScene(viewModel: Category.NavigateToScene.ViewModel.NavigateToAnotherScene)
}

class CategoryViewController: UIViewController {

    var interactor: CategoryBusinessLogic?
    var router: (NSObjectProtocol & CategoryRoutingLogic)?

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    private var categories = [CategoryCellInput]()

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

        configureTableView()
        interactor?.fetchData(request: .init())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        interactor?.configureUI(request: .init())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationItem.backButtonTitle = ""
    }

}

extension CategoryViewController: CategoryDisplayLogic {

    func configureUI(viewModel: Category.ConfigureUI.ViewModel.DisplayedNavBar) {
        navigationController?.navigationBar.barTintColor = viewModel.navigationBarTintColor
        navigationController?.navigationBar.tintColor = viewModel.navigationTintColor
        navigationItem.title = viewModel.title
    }

    func displayData(viewModel: Category.FetchData.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayNewCategories(let viewModel):
            categories = viewModel
        case .displayError(let error):
            print(error)
            categories = []
        }
        tableView.reloadData()
    }

    func navigateToOtherScene(viewModel: Category.NavigateToScene.ViewModel.NavigateToAnotherScene) {
        switch viewModel {
        case .routeSubcategories(let categoryBox):
            routeToSubscategoriesScreen(categoryBox)
         case .routeProducts(let subcategoryId):
            print("subcategoryId: \(subcategoryId)")
        }
    }

}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath)
        if let cell = cell as? CategoryCell {
            cell.configure(categories[indexPath.item])
        }
        return cell
    }

}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.navigateToScene(request: .init(index: indexPath.item))
    }

}

// MARK: Private methods

private extension CategoryViewController {

    func configureTableView() {
        tableView.register(
            UINib(nibName: CategoryCell.identifier, bundle: nil),
            forCellReuseIdentifier: CategoryCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
    }

    func routeToSubscategoriesScreen(_ categoryBox: CategoryBox) {
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.modalTransitionStyle = .partialCurl
        let subcategories = ScenesFactoryImpl.makeCategoriesScene(categoryBox).toPresent()
        navigationController?.pushViewController(subcategories, animated: true)
    }

}
