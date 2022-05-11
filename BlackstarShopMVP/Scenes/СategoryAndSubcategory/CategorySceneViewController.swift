//
//  CategorySceneViewController.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 18.05.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CategorySceneDisplayLogic: AnyObject {
    func configureUI(viewModel: CategorySceneModels.ViewModel.UIConfiguration)
    func updateUI(viewModel: CategorySceneModels.ViewModel.UIUpdating)
    func navigateToScene(viewModel: CategorySceneModels.ViewModel.Routing)
}

class CategorySceneViewController: UIViewController {

    var interactor: CategorySceneBusinessLogic?
    var router: (NSObjectProtocol & CategorySceneRoutingLogic)?

    // MARK: IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()

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
        interactor?.handleAction(request: .viewIsReady)
    }

}

// MARK: - CategoryDisplayLogic

extension CategorySceneViewController: CategorySceneDisplayLogic {

    func configureUI(viewModel: CategorySceneModels.ViewModel.UIConfiguration) {
        switch viewModel {
        case .navBarConfiguration(let viewModel):
            navigationController?.navigationBar.barTintColor = viewModel.navigationBarTintColor
            navigationController?.navigationBar.tintColor = viewModel.navigationTintColor
            navigationItem.backButtonTitle = ""
            navigationItem.title = viewModel.title
        case .refreshControl:
            refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
            tableView.refreshControl = refreshControl
        case .activityIndicatorShowing:
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        }
    }

    func updateUI(viewModel: CategorySceneModels.ViewModel.UIUpdating) {
        switch viewModel {
        case .tableViewDataReloading(let viewModel):
            categories = viewModel
            tableView.reloadData()
        case .tableViewErrorReloading(let error):
            print(error)
            categories = []
            tableView.reloadData()
        case .refreshControlHidding(let isHidden):
            refreshControl.endRefreshing()
            refreshControl.isHidden = isHidden
        case .activityIndicatorСlosing:
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }

    func navigateToScene(viewModel: CategorySceneModels.ViewModel.Routing) {
        switch viewModel {
        case .subcategoriesScene(let categoryBox):
            router?.showSubcategoryScene(categoryBox: categoryBox)
        case .productListScene(let subcategoryId):
            router?.showProductListScene(subcategoryId: "\(subcategoryId)")
        }
    }

}

// MARK: - UITableViewDataSource

extension CategorySceneViewController: UITableViewDataSource {

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

extension CategorySceneViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.handleAction(request: .cellTapped(indexPath.item))
    }

}

// MARK: Private methods

private extension CategorySceneViewController {

    func configureTableView() {
        tableView.register(UINib(nibName: CategoryCell.identifier, bundle: nil),
                           forCellReuseIdentifier: CategoryCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc func didPullToRefresh() {
        refreshControl.beginRefreshing()
        refreshControl.isHidden = true
        interactor?.handleAction(request: .didPullToRefresh)
    }

}
