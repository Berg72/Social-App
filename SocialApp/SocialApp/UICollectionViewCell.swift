//
//  UICollectionViewCell.swift
//  SocialApp
//
//  Created by Mark bergeson on 2/25/21.
//

import UIKit

extension UICollectionViewCell {
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
}
