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
    
    private var presenter: QuestionPresenterInput?
    var resultViewController: ResultViewController?
    var questionNumber = 0
    var questionTitle = ""
    var resultTitle = ""
    var prepareReciveData: (() -> Void)?
    var questionTitles = [String]()
    var selectedAnswers = [SelectedAnswers]()
    
    func inject(presenter: QuestionPresenterInput) {
        self.presenter = presenter
    }
    
    override func loadView() {
        super.loadView()
        self.navigationItem.leftBarButtonItem = backButton
        questionContentView.viewController = self
        selectAnserView.viewController = self
        reload()
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
    func reload() {
        presenter?.fetchQuestionData()
    }
    
    func resetQuestionNumber() {
        questionTitles = [String]()
        selectedAnswers = [SelectedAnswers]()
        questionNumber = 0
        reload()
    }
    
    func selectedAnswer(selected: SelectedAnswers) {
        appendQuestionToArray(selected: selected)
        questionNumber += 1
        reload()
    }
    
    func appendQuestionToArray(selected: SelectedAnswers) {
        questionTitles.append(questionTitle)
        selectedAnswers.append(selected)
    }
    func fetchResult(completion: @escaping () -> Void) {
        presenter?.fetchResultData(completion: completion)
    }
    func goResultVC() {
        prepareReciveData = ({ () in
            self.resultViewController = ResultViewController(questions: self.questionTitles, selectedAnswers: self.selectedAnswers)
            guard let resultViewController = self.resultViewController else { return }
            self.navigationController?.pushViewController(resultViewController, animated: true)
            resultViewController.resultDetailViewController.questions = self.questionTitles
            resultViewController.resultDetailViewController.selectedAnswers = self.selectedAnswers
            resultViewController.resultDetailViewController.delegate = self
        })
        guard let completion = prepareReciveData else { return }
        fetchResult(completion: completion)
    }
}

extension QuestionViewController: QuestionPresenterOutput {
    func passQuestionText(questionText: String) {
        questionContentView.questionTitle = questionText
        questionTitle = questionText
    }
    
    func passQuestionResult(title: String, description: String) {
        guard let resultViewController = resultViewController else { return }
        resultTitle = title
        resultViewController.resultTitle = title
        resultViewController.resultDescription = description
    }
    
    func giveQuextionIndex() -> Int {
        return questionNumber
    }
}

extension QuestionViewController: ResultDetailViewControllerDelegate {
    func saveQuestions(memoText: String) {
        
        presenter?.saveQuestions(title: resultTitle, questions: questionTitles, selectedAnswers: selectedAnswers, memoText: memoText)
    }

}
