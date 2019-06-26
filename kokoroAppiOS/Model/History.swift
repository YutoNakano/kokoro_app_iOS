//
//  History.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/23.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Firebase
import Foundation


struct History: FirestoreModelReadable, FirestoreModelWritable {
    enum Field: String {
        case title
        case questions
        case selectedAnswers
        case diagnosticTime
//        case memo
    }
    
    static var collectionRef: CollectionReference {
        return Firestore.firestore().collection("histories")
    }
    
    var title: String = ""
    var diagnosticTime: Timestamp
    var questions = [String]()
    var selectedAnswers = [String]()
//    var memo: String = ""
    
    init(snapshot: DocumentSnapshot) {
        title = snapshot.stringValue(forKey: Field.title, default: "")
        diagnosticTime = snapshot.getValue(forKey: Field.diagnosticTime) ?? Timestamp()
    }
    
    init(title: String, diagnosticTime: Timestamp = .init()) {
        self.title = title
        self.diagnosticTime = diagnosticTime
    }
    
    var writeFields: [Field : Any] {
        return [.title: title,
                .questions: questions,
                .selectedAnswers: selectedAnswers,
                .diagnosticTime: diagnosticTime]
    }
}
