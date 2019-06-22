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
        case name
    }
    
    static var collectionRef: CollectionReference {
        return Firestore.firestore().collection("Users")
    }
    
    var name: String = ""
    
    init(snapshot: DocumentSnapshot) {
        name = snapshot.stringValue(forKey: Field.name, default: "")
    }
    
    init(name: String) {
        self.name = name
    }
    
    var writeFields: [Field: Any] {
        return [.name: name]
    }
    
}
