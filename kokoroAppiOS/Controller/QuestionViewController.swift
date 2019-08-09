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
        v.delegate = self
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    var resultViewController: ResultViewController?
    var resultTitle = ""
    var isResult = false
    var questionNumber = 0
    var yesQuestionIndex = 0
    var noQuestionIndex = 0
    var nextIndex = 1
    var prepareReciveData: (() -> Void)?
    var questionTitles = [String]()
    var selectedAnswers = [SelectedAnswers]()
    var topViewController: TopViewController?
    
    var questionTitle: String? {
        didSet {
            self.setModel()
        }
    }
    
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
        /*
         ユーザーがYesを選択 -> Firestoreに持たせているyesQuestionIndexをnextIndexへ
         ユーザーがNoを選択 -> Firestoreに持たせているnoQuestionIndexをnextIndexへ
        */
        nextIndex = selected == .yes ? yesQuestionIndex : noQuestionIndex
        fetchQuestionData()
    }
    // ResultDetailVC(結果詳細画面)表示用の配列を作成
    func appendQuestionToArray(selected: SelectedAnswers) {
        guard let questions = questionTitle else { return }
        questionTitles.append(questions)
        selectedAnswers.append(selected)
    }
    
    func goResultVC() {
        guard let topViewController = topViewController else { return }
        resultViewController = ResultViewController(topVC: topViewController, questions: questionTitles, selectedAnswers: selectedAnswers)
        
        guard let resultViewController = resultViewController else { return }
        prepareReciveData = ({ [weak self] () in
            self?.navigationController?.pushViewController(resultViewController, animated: true)
        })
        
        guard let prepareReciveData = prepareReciveData else { return }
        guard let resultState = ResultViewType(rawValue: nextIndex) else { return }
        resultViewController.turnDescriptionStateView(resultState: resultState)
        resultViewController.fetchResultData(resultIndex: nextIndex, completion: prepareReciveData)
        
    }
}

extension QuestionViewController {
    func passQuestionText(questionText: String) {
        questionTitle = questionText
    }
    func setModel() {
        questionContentView.questionTitleLabel.text = questionTitle
        // 質問番号表示を+1する
        questionNumber += 1
        questionContentView.questionNumberLabel.text = "\(questionNumber)"
    }
}

extension QuestionViewController {
    func fetchQuestionData(){
        let db = Firestore.firestore()
        db.collection("Questions")
            .document(nextIndex.description)
            .getDocument { [weak self] document, error in
                if let err = error {
                    print(err)
                } else {
                    guard let isResult = document?.data()?["isResult"] as? Bool else { return }
                    self?.isResult = isResult
                    guard let yesQuestionIndex = document?.data()?["yes"] as? Int else { return }
                    self?.yesQuestionIndex = yesQuestionIndex
                    guard let noQuestionIndex = document?.data()?["no"] as? Int else { return }
                    self?.noQuestionIndex = noQuestionIndex
                    
                    guard let text = document?.data()?["title"] as? String else { return }
                    self?.passQuestionText(questionText: text)
                }
        }
    }
}

extension QuestionViewController: SelectAnserViewDelegate {
    func yesButtonTapped() {
        selectedAnswer(selected: .yes)
        validateIsResult()
    }
    func noButtonTapped() {
        selectedAnswer(selected: .no)
        validateIsResult()
    }
    // Firestoreに持たせているisResultプロパティがtrueだったら結果画面に画面遷移する
    func validateIsResult() {
        guard isResult else { return }
        goResultVC()
    }
}

