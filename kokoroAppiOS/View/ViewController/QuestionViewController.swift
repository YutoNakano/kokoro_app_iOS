//
//  QuestionViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseFirestore

final class QuestionViewController: ViewController {
    
    lazy var questionContentView: QuestionContentView = {
        let v = QuestionContentView()
        v.backgroundColor = UIColor.appColor(.background)
        view.addSubview(v)
        return v
    }()
    
    lazy var selectAnserView: SelectAnserView = {
        let v = SelectAnserView()
        v.backgroundColor = UIColor.appColor(.background)
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    private var presenter: QuestionPresenterInput?
    var questionNumber = 0
    var questionTitle = ""
    var questionTitles: [String]?
    var selectedAnswers: [Bool]?
    
    func inject(presenter: QuestionPresenterInput) {
        self.presenter = presenter
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        
    }
    
    override func loadView() {
        super.loadView()
        self.navigationItem.leftBarButtonItem = backButton
        questionContentView.viewController = self
        selectAnserView.viewController = self
        reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func makeConstraints() {
        questionContentView.snp.makeConstraints { make in
            make.height.equalTo(350)
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(selectAnserView.snp.top)
        }
        selectAnserView.snp.makeConstraints { make in
            make.top.equalTo(questionContentView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
}

extension QuestionViewController {
    @objc func backButtonTapped() {
        resetQuestionNumber()
        navigationController?.popViewController(animated: true)
    }
    func reload() {
        presenter?.fetchQuestionData()
    }
    
    func resetQuestionNumber() {
        questionNumber = 0
        reload()
    }
    
    func updateQuestionNumber(selectedYes: Bool) {
        questionTitles?.append(questionTitle)
        selectedAnswers?.append(selectedYes)
        questionNumber += 1
        reload()
    }
}

extension QuestionViewController: QuestionPresenterOutput {
    func giveQuextionIndex() -> Int {
        return questionNumber
    }
    
    func giveQuestionText(questionText: String) {
        questionContentView.questionTitle = questionText
        questionTitle = questionText
    }
    
}

