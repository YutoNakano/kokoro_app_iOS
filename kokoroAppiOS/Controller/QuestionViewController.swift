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

final class QuestionViewController: UIViewController {
    
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
    
    var resultViewController: ResultViewController?
    var questionNumber = 0
    var questionTitle = ""
    var resultTitle = ""
    var prepareReciveData: (() -> Void)?
    var questionTitles = [String]()
    var selectedAnswers = [SelectedAnswers]()
    
    override func loadView() {
        super.loadView()
        self.navigationItem.leftBarButtonItem = backButton
        questionContentView.viewController = self
        selectAnserView.viewController = self
        fetchQuestionData()
        setupView()
        makeConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
    }
    
    func makeConstraints() {
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
    
    func resetQuestionNumber() {
        questionTitles = [String]()
        selectedAnswers = [SelectedAnswers]()
        questionNumber = 0
        fetchQuestionData()
    }
    
    func selectedAnswer(selected: SelectedAnswers) {
        appendQuestionToArray(selected: selected)
        questionNumber += 1
        fetchQuestionData()
    }
    
    func appendQuestionToArray(selected: SelectedAnswers) {
        questionTitles.append(questionTitle)
        selectedAnswers.append(selected)
    }
    
    func goResultVC() {
        resultViewController = ResultViewController(questions: questionTitles, selectedAnswers: selectedAnswers)
        
        guard let resultViewController = resultViewController else { return }
        prepareReciveData = ({ () in
            self.navigationController?.pushViewController(resultViewController, animated: true)
        })
        
        guard let prepareReciveData = prepareReciveData else { return }
        resultViewController.fetchResultData(completion: prepareReciveData)
        
    }
}

extension QuestionViewController {
    func passQuestionText(questionText: String) {
        questionContentView.questionTitle = questionText
        questionTitle = questionText
    }
}

extension QuestionViewController {
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
                    self.passQuestionText(questionText: text)
                }
        }
    }
    func generateNextIndex() -> Int {
        return questionNumber + 1
    }
}



