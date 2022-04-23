//
//  UIImageView.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 19.05.2021.
//

import UIKit

extension UIImageView {

    // taken from https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview

    func load(url: URL?, placeholder: UIImage?, needMakeSquare: Bool = false) {
        guard let url = url else { return }
        DispatchQueue.global().async { [weak self] in
            var image: UIImage? = placeholder
            if let data = try? Data(contentsOf: url),
               let loadinbgImage = UIImage(data: data) {
                image = loadinbgImage
            }
            DispatchQueue.main.async {
                self?.image = needMakeSquare ? image?.cropBySquare() : image
            }
        }
    }
}
