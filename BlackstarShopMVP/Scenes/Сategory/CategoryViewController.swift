//
//  CategoryViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CategoryDisplayLogic: AnyObject {
    func displayData(viewModel: Category.FetchData.ViewModel.ViewModelData)
}

class CategoryViewController: UIViewController, CategoryDisplayLogic {

    var interactor: CategoryBusinessLogic?
    var router: (NSObjectProtocol & CategoryRoutingLogic)?

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    private var categories = [CategoryCellInput]()

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

        configureTableView()
        interactor?.makeRequest(request: .getData)
    }

    func displayData(viewModel: Category.FetchData.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayNewCategories(let viewModel):
            categories = viewModel
            tableView.reloadData()
        case .displayError(let error):
            categories = []
            tableView.reloadData()
            print(error)
        case .routeSubcategories(let state):
            routeToSubscategoriesScreen(state)
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

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.makeRequest(request: .handleCellTap(indexPath.item))
    }

}

// MARK: Public methods

extension CategoryViewController {

    func setScreenState(_ state: ScreenState) {
        interactor?.makeRequest(request: .setScreenState(state))
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

    func routeToSubscategoriesScreen(_ state: ScreenState) {
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.modalTransitionStyle = .partialCurl
        let vcontroller = CategoryViewController()
        vcontroller.setScreenState(state)
        navigationController?.pushViewController(vcontroller, animated: true)
    }

}
