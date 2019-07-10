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
        case timeStamp
    }
    
    static var collectionRef: CollectionReference {
        return Firestore.firestore().collection("histories")
    }
    
    var user_id: String = ""
    var title: String = ""
    var memo: String = ""
    var questions = [String]()
    var selectedAnswers = [String]()
    var timeStamp: Timestamp
    
    init(snapshot: DocumentSnapshot) {
        title = snapshot.stringValue(forKey: Field.title, default: "")
        memo = snapshot.stringValue(forKey: Field.memo, default: "")
        questions = snapshot.getValue(forKey: Field.questions) ?? [""]
        selectedAnswers = snapshot.getValue(forKey: Field.selectedAnswers) ?? [""]
        timeStamp = snapshot.getValue(forKey: Field.timeStamp) ?? Timestamp()
        let time = timeStamp.dateValue()
        let format = DateFormatter()
        format.dateFormat = "MM/dd HH:mm"
        print(format.string(from: time))
    }
    
    init(user_id: String, title: String, questions: [String], selectedAnswers: [String], memo: String, timeStamp: Timestamp = .init()) {
        self.user_id = user_id
        self.title = title
        self.questions = questions
        self.selectedAnswers = selectedAnswers
        self.memo = memo
        self.timeStamp = timeStamp
    }
    
    var writeFields: [Field : Any] {
        return [.user_id: user_id,
                .title: title,
                .questions: questions,
                .selectedAnswers: selectedAnswers,
                .memo: memo,
                .timeStamp: timeStamp]
    }
}
