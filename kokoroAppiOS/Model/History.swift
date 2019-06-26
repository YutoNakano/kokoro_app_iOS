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
        case user_id
        case title
        case questions
        case selectedAnswers
        case memo
        case diagnosticTime
    }
    
    static var collectionRef: CollectionReference {
        return Firestore.firestore().collection("histories")
    }
    
    var user_id: String = ""
    var title: String = ""
    var memo: String = ""
    var questions = [String]()
    var selectedAnswers = [String]()
    var diagnosticTime: Timestamp
    
    init(snapshot: DocumentSnapshot) {
        title = snapshot.stringValue(forKey: Field.title, default: "")
        diagnosticTime = snapshot.getValue(forKey: Field.diagnosticTime) ?? Timestamp()
    }
    
    init(user_id: String, title: String, questions: [String], selectedAnswers: [String], memo: String, diagnosticTime: Timestamp = .init()) {
        self.user_id = user_id
        self.title = title
        self.questions = questions
        self.selectedAnswers = selectedAnswers
        self.memo = memo
        self.diagnosticTime = diagnosticTime
    }
    
    var writeFields: [Field : Any] {
        return [.user_id: user_id,
                .title: title,
                .questions: questions,
                .selectedAnswers: selectedAnswers,
                .memo: memo,
                .diagnosticTime: diagnosticTime]
    }
}
