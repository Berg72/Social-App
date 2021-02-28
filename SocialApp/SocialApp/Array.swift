//
//  Array.swift
//  SocialApp
//
//  Created by Mark bergeson on 2/27/21.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
