//
//  UIImageView.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 19.05.2021.
//

import UIKit

extension UIImageView {

    // taken from https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview

    func load(url: URL?, placeholder: UIImage?) {
        guard let url = url else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) ?? placeholder {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }

}
