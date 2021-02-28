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
    var deniedBy: String?
    var moderated: Bool
    var reportedBy: [String]
    var imageUrls: [String]?
    var created: Double
    var createdBy: String
    var lastUpdated: Double
    var lastUpdatedBy: String
    var archived: Bool
    var archivedAt: Double?
}

extension Post {
    
    static func getPost(onComplete: @escaping (_ posts: [Post]?, _ error: Error?) -> ()) {
        Database.shared.db.collection(collectionName.rawValue).whereField("moderated", isEqualTo: true).whereField("visibleToPublic", isEqualTo: true).getDocuments { (snapshot, error) in
            
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
    static func getPostModerate(onComplete: @escaping (_ posts: [Post]?, _ error: Error?) -> ()) {
        Database.shared.db.collection(collectionName.rawValue).whereField("moderated", isEqualTo: false).getDocuments { (snapshot, error) in
            
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
    static func getPost(postId: String, onComplete: @escaping (_ post: Post?, _ error: Error?) -> ()) {
        Database.shared.db.collection(collectionName.rawValue).document(postId).getDocument { (snapshot, error) in
            if let error = error {
                onComplete(nil, error)
                return
            }
            
            guard let documents = snapshot else {
                onComplete(nil, nil)
                return
            }
            
            do {
                let obj = try documents.decode(as: Post.self)
                onComplete(obj, nil)
            } catch {
                print(error)
                onComplete(nil, error)
            }
            
        
    }
}

}
