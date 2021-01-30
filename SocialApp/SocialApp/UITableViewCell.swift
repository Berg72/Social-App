//
//  UiTableViewCell.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/15/21.
//

import UIKit

extension UITableViewCell {
    
    class func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
