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
    var questionTitle = ""
    var resultTitle = ""
    var isResult = false
    var yesQuestionIndex = 0
    var noQuestionIndex = 0
    var nextIndex = 1
    var prepareReciveData: (() -> Void)?
    var questionTitles = [String]()
    var selectedAnswers = [SelectedAnswers]()
    var topViewController: TopViewController?
    
    init(topVC: TopViewController) {
        topViewController = topVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        yesQuestionIndex = 0
        noQuestionIndex = 0
        nextIndex = 1
        fetchQuestionData()
    }
    
    func selectedAnswer(selected: SelectedAnswers) {
        appendQuestionToArray(selected: selected)
        nextIndex = selected == .yes ? yesQuestionIndex : noQuestionIndex
        fetchQuestionData()
    }
    // ResultDetailVC表示用の配列を作成
    func appendQuestionToArray(selected: SelectedAnswers) {
        questionTitles.append(questionTitle)
        selectedAnswers.append(selected)
    }
    
    func goResultVC() {
        resultViewController = ResultViewController(topVC: topViewController!, questions: questionTitles, selectedAnswers: selectedAnswers)
        
        guard let resultViewController = resultViewController else { return }
        prepareReciveData = ({ () in
            let navi = NavigationController(rootViewController: resultViewController)
           self.present(navi, animated: true, completion: nil)
        })
        
        guard let prepareReciveData = prepareReciveData else { return }
        resultViewController.fetchResultData(resultIndex: nextIndex, completion: prepareReciveData)
        
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
            .document(nextIndex.description)
            .getDocument { document, error in
                if let err = error {
                    print(err)
                } else {
                    guard let isResult = document?.data()?["isResult"] as? Bool else { return }
                    self.isResult = isResult
                    guard let yesQuestionIndex = document?.data()?["yes"] as? Int else { return }
                    self.yesQuestionIndex = yesQuestionIndex
                    guard let noQuestionIndex = document?.data()?["no"] as? Int else { return }
                    self.noQuestionIndex = noQuestionIndex
                    
                    guard let text = document?.data()?["title"] as? String else { return }
                    print(document?.data()! ?? "質問なし")
                    self.passQuestionText(questionText: text)
                }
        }
    }
}



