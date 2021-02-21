//
//  Alert.swift
//  SocialApp
//
//  Created by Mark bergeson on 2/18/21.
//

import Foundation

struct Alert: SMAObject {
    static let collectionName = CollectionName.Alert
    
    var id: String?
    var postid: String?
    var authorImgUrl: String?
    var authorName: String?
    var subject: String?
    var text: String
    var created: Double
    var createdBy: String
    var lastUpdated: Double
    var lastUpdatedBy: String
    var archived: Bool
    var archivedAt: Double?
}

extension Alert {
    
    static func getAlerts(onComplete: @escaping (_ alerts: [Alert]?, _ error: Error?) -> ()) {
        Database.shared.db.collection(collectionName.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                onComplete(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                onComplete(nil, nil)
                return
            }
            var objects = [Alert]()
            for document in documents {
                do {
                    let obj = try document.decode(as: Alert.self)
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
