//
//  QuestionViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import APIKit

final class QuestionViewController: ViewController {
    
    lazy var questionContentView: QuestionContentView = {
        let v = QuestionContentView()
        view.addSubview(v)
        return v
    }()
    
    lazy var selectAnserView: SelectAnserView = {
        let v = SelectAnserView()
        view.addSubview(v)
        return v
    }()
    
    
    override func setupView() {
        view.backgroundColor = UIColor.white
    }
    
    override func loadView() {
//            Session.send(QuestionResponse.SearchRepositories()) { result in
//                switch result {
//                case .success(let response):
//                    print(response)
//                case .failure(let error):
//                    print(error)
//                }
//            }
//
//
//            Session.send(ResultResponse.SearchRepositories()) { result in
//                switch result {
//                case .success(let response):
//                    print(response)
//                case .failure(let error):
//                    print(error)
//                }
//            }
    }
    
    override func makeConstraints() {
        questionContentView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(500)
            make.bottom.equalTo(selectAnserView.snp.top)
        }
        selectAnserView.snp.makeConstraints { make in
            make.top.equalTo(questionContentView.snp.top)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    
    
    
}
