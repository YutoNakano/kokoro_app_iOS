//
//  ResultViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import LTMorphingLabel


final class ResultViewController: ViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.appColor(.navbar)
        v.layer.cornerRadius = 10
        v.layer.shadowOpacity = 0.1
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        v.layer.shadowRadius = 10
        view.addSubview(v)
        return v
    }()
    
    lazy var titleLabel: LTMorphingLabel = {
        let v = LTMorphingLabel()
        v.numberOfLines = 0
        v.morphingEffect = .scale
        v.text = "診断結果: 心療内科"
        v.font = UIFont(name: "GillSans", size: 28)
        contentView.addSubview(v)
        return v
    }()
    
    lazy var historyCollectionView: HistoryCollectionView = {
        let v = HistoryCollectionView()
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    
    override func loadView() {
        super.loadView()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.appColor(.background)
    }
    
    override func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(30)
            make.height.equalTo(300)
            make.width.equalTo(screenWidth - 30)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(screenWidth - 30)
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        historyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(30)
            make.width.equalTo(screenWidth - 30)
            make.centerX.equalToSuperview()
        }
    }
    
    
}

extension ResultViewController {
    @objc func backButtonTapped() {       self.navigationController?.popToRootViewController(animated: true)
    }
}

