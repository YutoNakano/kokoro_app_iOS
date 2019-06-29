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
    func fetchResultData(completion: @escaping () -> Void)
    func saveQuestions(title: String, questions: [String], selectedAnswers: [SelectedAnswers], memoText: String)
}

protocol QuestionPresenterOutput: AnyObject {
    func passQuestionText(questionText: String)
    func passQuestionResult(title: String, description: String)
    func giveQuextionIndex() -> Int
}


final class QuestionPresenter {
    
    private weak var view: QuestionPresenterOutput?
    
    init(view: QuestionPresenterOutput) {
        self.view = view
    }
    
}


extension QuestionPresenter: QuestionPresenterInput {
    func fetchQuestionData(){
        let db = Firestore.firestore()
        db.collection("Questions")
            .document(generateNextIndex().description)
            .getDocument { document, error in
                if let err = error {
                    print(err)
                } else {
                    guard let text = document?.data()?["title"] as? String else { return }
                    print(document?.data()! ?? "結果なし")
                    self.view?.passQuestionText(questionText: text)
                }
        }
    }
    
    func fetchResultData(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("results")
            .document("psychosomatic")
            .getDocument { document, error in
                if let err = error {
                    print(err)
                } else {
                    guard let title = document?.data()?["title"] as? String else { return }
                    guard let description = document?.data()?["description"] as? String else { return }
                    print(document?.data()! ?? "質問なし")
                    completion()
                    self.view?.passQuestionResult(title: title, description: description)
                }
        }
    }

    func saveQuestions(title: String, questions: [String], selectedAnswers: [SelectedAnswers], memoText: String) {
        guard let user = UserManager.shared.currentUser else { return }
        let user_id = user.data.user_id
        let answersString = selectedAnswers.map { $0.rawValue }
        print(title)
        print(questions)
        print(answersString)
        print(memoText)
        let history = History(user_id: user_id, title: title, questions: questions, selectedAnswers: answersString, memo: memoText)
        Document<History>.create(model: history) { result in
            print(result)
        }
    }
    
}

extension QuestionPresenter {
    func generateNextIndex() -> Int {
        guard let questionIndex = view?.giveQuextionIndex() else { return 1 }
            return questionIndex + 1
    }
}
