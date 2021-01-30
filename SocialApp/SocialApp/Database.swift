//
//  Database.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/19/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum CollectionName: String {
    case User
    case Post
    
}

protocol SMAObject: Codable {
    static var collectionName : CollectionName { get }
    var id: String? {get set}
    var created: Double {get set}
    var createdBy: String {get set}
    var lastUpdated: Double {get set}
    var lastUpdatedBy: String {get set}
    var archived: Bool {get set}
    var archivedAt: Double? {get set}
}

class Database {
    static let shared = Database()
    let db: Firestore
    
    var currentUser: User?
    
    private init() {
        let firestoreSettings = FirestoreSettings()
        firestoreSettings.isPersistenceEnabled = false
        
        self.db = Firestore.firestore()
        db.settings = firestoreSettings
    }
}

private extension Database {
    
    func getCollection(_ obj: SMAObject) -> CollectionReference {
        return getCollection(type(of: obj).collectionName)
    }
    
    func getCollection(_ name: CollectionName) -> CollectionReference {
        return db.collection(name.rawValue)
    }
    
    func getDocumentRef(_ obj: SMAObject) -> DocumentReference {
        let collection = getCollection(obj)
        
        if let id = obj.id {
            return collection.document(id)
        } else {
            return collection.document()
        }
    }
}



extension Database {
    
    func save<T: SMAObject>(_ object: T, onComplete: @escaping (_ savedObject: T?, _ error: Error? ) -> Void) {
        var obj = object
        obj.lastUpdated = Date().timeIntervalSince1970
        obj.lastUpdatedBy = Auth.auth().currentUser?.uid ?? ""
        let ref = getDocumentRef(obj)
        do {
            let data = try obj.toFirestoreData()
            ref.setData(data, merge: true) { (error) in
                var savedObject = obj
                savedObject.id = ref.documentID
                if let error = error {
                    onComplete(nil, error)
                }
                onComplete(savedObject, error)
            }
        } catch {
            onComplete(nil, error)
        }
    }
}
