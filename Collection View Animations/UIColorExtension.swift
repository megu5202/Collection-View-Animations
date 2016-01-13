//
//  UIColorExtension.swift
//  Collection View Animations
//
//  Created by jesse calkin on 1/12/16.
//  Copyright © 2016 jesse calkin. All rights reserved.
//

import UIKit

func randomCGFloat() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
}

extension UIColor {
    static func randomColor() -> UIColor {
        let r = randomCGFloat()
        let g = randomCGFloat()
        let b = randomCGFloat()

        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}