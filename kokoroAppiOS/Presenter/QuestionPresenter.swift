//
//  QuestionPresenter.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/17.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import APIKit


protocol QuestionPresenterInput {
    func didTapStartButton()
}

protocol QuestionPresenterOutput: AnyObject {
    func reload(data: Question)
}


final class QuestionPresenter {
    
    private weak var view: QuestionPresenterOutput?
    
    init(view: QuestionPresenterOutput) {
        self.view = view
    }
    
}


extension QuestionPresenter: QuestionPresenterInput {
    func didTapStartButton() {
        Session.send(QuestionResponse.SearchRepositories()) { result in
            switch result {
            case .success(let response):
                print(response)
                self.view?.reload(data: response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
