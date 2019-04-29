//
//  UIView+addBorder.swift
//  Eagle Books 2.0
//
//  Created by Lindsay Braun on 4/25/19.
//  Copyright © 2019 Lindsay Braun. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBorder(width: CGFloat, radius: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
    }
    
    func noBorder() {
        self.layer.borderWidth = 0.0
    }
}
