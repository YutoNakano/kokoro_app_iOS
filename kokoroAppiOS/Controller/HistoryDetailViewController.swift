//
//  HistoryDetailViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/29.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class HistoryDetailViewController: UIViewController {
    
    lazy var historyDetailCollectionView: HistoryDetailCollectionView = {
        let v = HistoryDetailCollectionView()
        view.addSubview(v)
        return v
    }()
    
    lazy var memoLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.font = UIFont(name: "GillSans", size: 16)
        v.textColor = UIColor.appColor(.character)
        v.layer.cornerRadius = 5
        v.backgroundColor = UIColor.appColor(.navbar)
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    var questions: [String]
    var selectedAnswersString: [String]
    var memoText: String
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    init(questions: [String], selectedAnswersString: [String], memoText: String) {
        self.questions = questions
        self.selectedAnswersString = selectedAnswersString
        self.memoText = memoText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
        setModel()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setupView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
        view.backgroundColor = UIColor.appColor(.background)
    }
    
    func makeConstraints() {
        historyDetailCollectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        memoLabel.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.top.equalTo(historyDetailCollectionView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
}

extension HistoryDetailViewController {
    func setModel() {
        historyDetailCollectionView.questions = questions
        historyDetailCollectionView.selectedAnswersString = selectedAnswersString
        memoLabel.text = memoText
    }
    @objc func goTopButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


