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

    @IBOutlet private weak var sliderView: ImageHorizontalCollectionView!

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

        let imageUrlStrings = [
            "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-466881-jpeg.jpg",
            "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-466910-jpeg.jpg",
            "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-466925-jpeg.jpg",
            "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-466931-jpeg.jpg",
            "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-466978-jpeg.jpg",
            "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-467028-jpeg.jpg",
            "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-467032-jpeg.jpg",
            "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-467042-jpeg.jpg",
            "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-467052-jpeg.jpg"
        ]

        let imageUrls = imageUrlStrings.map { URL(string: $0)! }

        sliderView.configure(imageUrls)

        self.automaticallyAdjustsScrollViewInsets = false

        //setNavigationBar()
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

    func displayData(viewModel: ProductScene.Model.ViewModel.ViewModelData) {

    }

}

extension ProductSceneViewController {
    func setNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
}
