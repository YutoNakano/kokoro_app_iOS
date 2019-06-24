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

final class ResultDetailViewController: ViewController {
    
    lazy var historyCollectionView: HistoryDetailCollectionView = {
        let v = HistoryDetailCollectionView()
        view.addSubview(v)
        return v
    }()
    
    lazy var memoTextView: UITextView = {
        let v = UITextView()
        v.text = "自分の心の内側をメモしておきましょう"
        v.font = UIFont(name: "GillSans", size: 28)
        v.textColor = UIColor.appColor(.character)
        v.layer.cornerRadius = 5
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
    
    let screenWidth = UIScreen.main.bounds.width
    let memoText: String = ""
    
    override func loadView() {
        super.loadView()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    override func makeConstraints() {
        historyCollectionView.snp.makeConstraints { make in
            make.height.equalTo(350)
            make.top.left.right.equalToSuperview()
        }
        memoTextView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.top.equalTo(historyCollectionView.snp.bottom).offset(30)
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
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ResultDetailViewController: UITextViewDelegate {
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (memoTextView.isFirstResponder) {
            memoTextView.resignFirstResponder()
        }
    }
}
