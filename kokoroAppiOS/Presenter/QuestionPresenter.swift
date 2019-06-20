//
//  QuestionPresenter.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/17.
//  Copyright © 2019 中野湧仁. All rights reserved.
//
import Foundation
import FirebaseFirestore


protocol QuestionPresenterInput {
    func fetchQuestionData()
    func fetchResultData()
}

protocol QuestionPresenterOutput: AnyObject {
    func giveQuestionText(questionText: String)
    func giveQuextionIndex() -> Int
}


final class QuestionPresenter {
    
    private weak var view: QuestionPresenterOutput?
    
    init(view: QuestionPresenterOutput) {
        self.view = view
    }
    
}


extension QuestionPresenter: QuestionPresenterInput {
    func fetchResultData() {
        
    }
    
    func fetchQuestionData(){
        let db = Firestore.firestore()
        db.collection("Questions")
            .document(generateNextIndex().description)
            .getDocument { document, error in
                if let err = error {
                    print(err)
                } else {
                    guard let text = document?.data()?["title"] as? String else { return }
                    print(document?.data()!)
                    self.view?.giveQuestionText(questionText: text)
                }
        }
    }
}

extension QuestionPresenter {
    func generateNextIndex() -> Int {
        guard let questionIndex = view?.giveQuextionIndex() else { return 1 }
            return questionIndex + 1
    }
}
