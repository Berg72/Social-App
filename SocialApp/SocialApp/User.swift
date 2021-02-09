//
//  User.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/19/21.
//

import Foundation

struct User : SMAObject {
    static let collectionName = CollectionName.User
    
    var id: String?
    var apnsToken: String?
    var name: String?
    var email: String?
    let role: UserRole
    var profileImageUrl: String?
    var created: Double
    var createdBy: String
    var lastUpdated: Double
    var lastUpdatedBy: String
    var archived: Bool
    var archivedAt: Double?
}

enum UserRole: String, Codable {
    case user
    case admin
}

extension User {
    
    static func getUser(userID: String, onComplete: @escaping (_ user: User?, _ error: Error?) -> ()) {
        Database.shared.db.collection(collectionName.rawValue).document(userID).getDocument { (snapshot, error) in
            if let error = error {
                onComplete(nil, error)
                return
            }
            
            guard let documents = snapshot else {
                onComplete(nil, nil)
                return
            }
            
            do {
                let obj = try documents.decode(as: User.self)
                onComplete(obj, nil)
            } catch {
                print(error)
                onComplete(nil, error)
            }
            
        
    }
}
}
