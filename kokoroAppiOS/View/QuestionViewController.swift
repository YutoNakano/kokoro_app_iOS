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
        questionContentView.viewController = self
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

extension QuestionViewController: QuestionPresenterOutput {
    func reload(data: Question) {
        questionContentView.question = data
        loadView()
        viewDidLoad()
    }
}
