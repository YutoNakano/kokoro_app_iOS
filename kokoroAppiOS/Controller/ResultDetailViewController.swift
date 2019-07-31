//
//  ResultDetailViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/24.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import FirebaseFirestore

protocol ResultDetailViewControllerDelegate: class {
    func saveQuestions(memoText: String)
}

final class ResultDetailViewController: UIViewController {
    
    lazy var resultCollectionView: ResultCollectionView = {
        let v = ResultCollectionView()
        view.addSubview(v)
        return v
    }()
    
    lazy var memoExplainLabel: UILabel = {
        let v = UILabel()
        v.text = "メモに現在の心身の状況を記録しましょう"
        v.textColor = UIColor.appColor(.character)
        v.font = UIFont(name: "RoundedMplus1c-Medium", size: 14)
        view.addSubview(v)
        return v
    }()
    
    lazy var memoTextView: PlaceHolderTextView = {
        let v = PlaceHolderTextView()
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(closeButtonTapped))
        toolBar.items = [spacer, closeButton]
        v.inputAccessoryView = toolBar
        v.placeHolder = "ここに入力ください"
        v.delegate = self
        view.addSubview(v)
        return v
    }()
    
    lazy var maxCharactorsAlartLabel: UILabel = {
        let v = UILabel()
        v.text = "300文字以上は入力できません"
        v.font = UIFont(name: "RoundedMplus1c-Medium", size: 20)
        v.backgroundColor = UIColor.appColor(.alartRed)
        v.isHidden = true
        view.addSubview(v)
        return v
    }()
    
    lazy var goTopButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("保存・TOPへ", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 28)
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 20
        v.addTarget(self, action: #selector(goTopButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    var resultTitle: String?
    var questions: [String]?
    var selectedAnswers: [SelectedAnswers]?
    weak var delegate: ResultDetailViewControllerDelegate?
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    var memoText: String = ""
    let userDefaults = UserDefaults.standard
    let topViewController: TopViewController?
    
    init(topVC: TopViewController,title: String, questions: [String], selectedAnswers: [SelectedAnswers]) {
        topViewController = topVC
        self.resultTitle = title
        self.questions = questions
        self.selectedAnswers = selectedAnswers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureObserver()
        readMemoText()
        guard let questions = questions else { return }
        resultCollectionView.questions = questions
        guard let selectedAnswers = selectedAnswers else { return }
        resultCollectionView.selectedAnswers = selectedAnswers
        memoTextView.changeVisiblePlaceHolder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resultCollectionView.collectionView.flashScrollIndicators()
    }
    
    func setupView() {
        self.navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
        view.backgroundColor = UIColor.appColor(.background)
    }
    
    func makeConstraints() {
        resultCollectionView.snp.makeConstraints { make in
            make.height.equalTo(350)
            make.top.left.right.equalToSuperview()
        }
        memoExplainLabel.snp.makeConstraints { make in
            make.bottom.equalTo(memoTextView.snp.top).offset(-2)
            make.left.equalTo(memoTextView.snp.left)
        }
        memoTextView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.top.equalTo(resultCollectionView.snp.bottom).offset(35)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        maxCharactorsAlartLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(memoTextView.snp.bottom).offset(5)
        }
        goTopButton.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(40)
            make.centerX.equalTo(memoTextView.snp.centerX)
            make.height.equalTo(80)
            make.width.equalTo(220)
        }
    }
}

extension ResultDetailViewController {
    @objc func goTopButtonTapped() {
        userDefaults.removeObject(forKey: "memoText")
        guard let resultTitle = resultTitle, let questions = questions, let selectedAnswers = selectedAnswers else { return }
        saveQuestions(title: resultTitle, questions: questions, selectedAnswers: selectedAnswers, memoText: memoTextView.text)
        topViewController?.setCharactorDescription()
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func backButtonTapped() {
        userDefaults.set(memoText, forKey: "memoText")
        userDefaults.synchronize()
        navigationController?.popViewController(animated: true)
    }
    @objc func closeButtonTapped() {
        self.view.endEditing(true)
    }
    
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification?) {

        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let showDuration = duration else { return }
        UIView.animate(withDuration: showDuration, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -200)
            self.view.transform = transform
            
        })
        memoTextView.changeVisiblePlaceHolder()
    }
    @objc func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        guard let hideDuration = duration else { return }
        UIView.animate(withDuration: hideDuration, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
        memoTextView.changeVisiblePlaceHolder()
    }
    
    func readMemoText() {
        memoTextView.text = userDefaults.string(forKey: "memoText")
    }
}

extension ResultDetailViewController: UITextViewDelegate {
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        memoTextView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
            memoText = textView.text
        if textView.text.count > 300 {
            let zero = memoText.startIndex
            let start = memoText.index(zero, offsetBy: 0)
            let end = memoText.index(zero, offsetBy: 300)
            textView.text = String(memoText[start...end])
            textView.isHidden = false
        }
    }
}

extension ResultDetailViewController {
    func saveQuestions(title: String, questions: [String], selectedAnswers: [SelectedAnswers], memoText: String) {
        guard let user = UserManager.shared.currentUser else { return }
        let user_id = user.data.user_id
        let answersString = selectedAnswers.map { $0.rawValue }
        print(title)
        print(questions)
        print(answersString)
        print(memoText)
        let history = History(user_id: user_id, title: title, questions: questions, selectedAnswers: answersString, memo: memoText)
        Document<History>.create(model: history) { result in
            print(result)
        }
    }
}
