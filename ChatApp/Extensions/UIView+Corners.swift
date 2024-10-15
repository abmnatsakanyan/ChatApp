//
//  UIView+Corners.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/14/24.
//

import UIKit

extension UIView {
    func roundSentCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
