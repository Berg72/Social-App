//
//  Encodable.swift
//  SocialApp
//
//  Created by Mark bergeson on 1/19/21.
//

import Foundation
import FirebaseFirestore
import Firebase
import CodableFirebase

enum EncodableExtensionError:Error {
    case encodingError
}

extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}

extension Encodable {
    func toFirestoreData(excluding excludedKeys: [String] = ["id"] ) throws -> [String: Any] {
        
        let encoder = FirestoreEncoder()
        var docData = try! encoder.encode(self)
        
        for key in excludedKeys {
            docData.removeValue(forKey: key)
        }
        
        return docData
    }
    
}
