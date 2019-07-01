//
//  User.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/22.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Firebase
import Foundation

struct User: FirestoreModelReadable, FirestoreModelWritable {
    
    enum Field: String {
        case user_id
        case name
        case timeStamp
    }
    
    static var collectionRef: CollectionReference {
        return Firestore.firestore().collection("users")
    }
    
    var user_id: String = ""
    var name: String = ""
    var timeStamp: Timestamp
    
    init(snapshot: DocumentSnapshot) {
        user_id = snapshot.stringValue(forKey: Field.user_id, default: "")
        name = snapshot.stringValue(forKey: Field.name, default: "")
        timeStamp = snapshot.getValue(forKey: Field.timeStamp) ?? Timestamp()
    }
    
    init(user_id: String, name: String, timeStamp: Timestamp = .init()) {
        self.user_id = user_id
        self.name = name
        self.timeStamp = timeStamp
    }
    
    var writeFields: [Field: Any] {
        return [
            .user_id: user_id,
            .name: name,
            .timeStamp: timeStamp]
    }
    
}
