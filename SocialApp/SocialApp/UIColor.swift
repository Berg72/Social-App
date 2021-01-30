//
//  UIColor.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/15/21.
//

import UIKit

enum AssetColorName: String, Codable {
    case backgroundcolor = "Background Color"
    case shadowColor = "Shadow Color"
    case primaryTextColor = "Primary Text Color"
    case secondaryTextColor = "Secondary Text Color"
}


extension UIColor {
    
    static func color(_ colorName: AssetColorName) -> UIColor {
        if let color = UIColor(named:  colorName.rawValue) {
            return color
        } else {
            fatalError("This color doesn't exist: \(colorName.rawValue)")
        }
    }
}
