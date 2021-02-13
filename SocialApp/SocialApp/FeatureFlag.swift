//
//  FeatureFlag.swift
//  SocialApp
//
//  Created by Mark bergeson on 2/4/21.
//

import Foundation

enum FeatureFlag {
    case tabs
    case comments
        
    
    func enabled() -> Bool {
        switch self {
        case .tabs:
            return false
        case .comments:
            return false
            
        }
    }

}
