//
//  Post.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/19/21.
//

import Foundation

struct Post: SMAObject {
    static let collectionName = CollectionName.Post 
    
    var id: String?
    var authorImgUrl: String?
    var authorName: String?
    var text: String
    var commentCount: Int
    var visibleToPublic: Bool
    var approvedBy: String?
    var DeniedBy: String?
    var moderated: Bool
    var reportedBy: [String]
    var created: Double
    var createdBy: String
    var lastUpdated: Double
    var lastUpdatedBy: String
    var archived: Bool
    var archivedAt: Double?
}

extension Post {
    static func getPost(onComplete: @escaping (_ posts: [Post]?, _ error: Error?) -> ()) {
        Database.shared.db.collection(collectionName.rawValue).getDocuments { (snapshot, error) in
            
            if let error = error {
                onComplete(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                onComplete(nil, nil)
                return
            }
            var objects = [Post]()
            for document in documents {
                do {
                    let obj = try document.decode(as: Post.self)
                    objects.append(obj)
                } catch {
                    print(error)
                    onComplete(nil, error)
                }
            }
            onComplete(objects, nil)
        }
    }

}
