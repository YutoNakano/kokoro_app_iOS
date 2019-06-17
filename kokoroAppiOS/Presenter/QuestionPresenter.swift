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
    func reload()
}


final class QuestionPresenter {
    
    private weak var view: QuestionPresenterOutput?
    
    init(view: QuestionPresenterOutput) {
        self.view = view
    }
    
}


extension QuestionPresenter: QuestionPresenterInput {
    func didTapStartButton() {
        view?.reload()
    }
}
