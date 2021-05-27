//
//  UIImage.swift
//  BlackstarShopMVP
//
//  Created by Игорь Никифоров on 27.05.2021.
//

import UIKit

extension UIImage {

    func cropBySquare() -> UIImage {
        guard self.size.width != self.size.height else { return self }
        let side = min(self.size.width, self.size.height)
        let square = CGRect(x: 0, y: 0, width: side, height: side)
        if let cgImage = self.cgImage,
        let croppedCGImage = cgImage.cropping(to: square) {
            return UIImage(cgImage: croppedCGImage)
        }
        return self
    }

}
