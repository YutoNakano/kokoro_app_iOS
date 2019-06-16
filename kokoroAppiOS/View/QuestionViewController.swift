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
        v.backgroundColor = UIColor.white
        view.addSubview(v)
        return v
    }()
    
    lazy var selectAnserView: SelectAnserView = {
        let v = SelectAnserView()
        v.backgroundColor = UIColor.white
        view.addSubview(v)
        return v
    }()
    
    override func setupView() {
        view.backgroundColor = UIColor.white
    }
    
    override func loadView() {
        super.loadView()
            Session.send(QuestionResponse.SearchRepositories()) { result in
                switch result {
                case .success(let response):
                    print(response)
                    self.questionContentView.question = response
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func makeConstraints() {
        questionContentView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(selectAnserView.snp.top)
        }
        selectAnserView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.top.equalTo(questionContentView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    
    
    
}
