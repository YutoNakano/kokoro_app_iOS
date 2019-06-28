//
//  HistoryPresenter.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/27.
//  Copyright © 2019 中野湧仁. All rights reserved.
//



import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol HistoryPresenterInput {
    func fetchResultData()
}

protocol HistoryPresenterOutput: AnyObject {
    func passQuestionResult(histories: [Document<History>])
}


final class HistoryPresenter {
    private weak var view: HistoryPresenterOutput?

    init(view: HistoryPresenterOutput) {
        self.view = view
    }
}

extension HistoryPresenter: HistoryPresenterInput {
    func fetchResultData() {
        guard let user = UserManager.shared.currentUser else { return }
        let user_id = user.data.user_id
        Document<History>.get(queryBuilder: { q in
            q.whereField("user_id", isEqualTo: user_id)
                .order(by: "diagnosticTime", descending: true)}) { result in
                    switch result {
                    case let .success(histories):
                        print(histories)
                        self.view?.passQuestionResult(histories: histories)
                    case let .failure(error):
                        print(error)
                    }
        }
    }
    
}
