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

protocol ResultDetailViewControllerDelegate: class {
    func saveQuestions(memoText: String)
}

final class ResultDetailViewController: UIViewController {
    
    lazy var resultCollectionView: ResultCollectionView = {
        let v = ResultCollectionView()
        view.addSubview(v)
        return v
    }()
    
    lazy var memoTextView: PlaceHolderTextView = {
        let v = PlaceHolderTextView()
        v.font = UIFont(name: "GillSans", size: 16)
        v.textColor = UIColor.appColor(.character)
        v.layer.cornerRadius = 5
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(closeButtonTapped))
        toolBar.items = [spacer, closeButton]
        v.inputAccessoryView = toolBar
        v.placeHolder = "今の状態をメモしましょう"
        v.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        v.backgroundColor = UIColor.appColor(.navbar)
        
        v.delegate = self
        view.addSubview(v)
        return v
    }()
    lazy var goTopButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("TOPへ", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 28)
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
    
    var questions: [String]?
    var selectedAnswers: [SelectedAnswers]?
    weak var delegate: ResultDetailViewControllerDelegate?
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    let memoText: String = ""
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
        self.navigationItem.leftBarButtonItem = backButton
        configureObserver()
        guard let questions = questions else { return }
        resultCollectionView.questions = questions
        guard let selectedAnswers = selectedAnswers else { return }
        resultCollectionView.selectedAnswers = selectedAnswers
    }
    
    func setupView() {
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
        memoTextView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.top.equalTo(resultCollectionView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
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
        delegate?.saveQuestions(memoText: memoTextView.text)
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func backButtonTapped() {
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
        
//        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -200)
            self.view.transform = transform
            
        })
        memoTextView.changeVisiblePlaceHolder()
    }
    @objc func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
        memoTextView.changeVisiblePlaceHolder()
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
}
