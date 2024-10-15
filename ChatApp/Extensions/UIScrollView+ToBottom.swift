//
//  UIScrollView+ToBottom.swift
//  ChatApp
//
//  Created by Albert Mnatsakanyan on 10/15/24.
//

import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        let point = CGPoint(x: 0, y: contentSize.height + contentInset.bottom - frame.height)
        
        if point.y >= 0 {
            self.setContentOffset(point, animated: animated)
        }
    }
}
