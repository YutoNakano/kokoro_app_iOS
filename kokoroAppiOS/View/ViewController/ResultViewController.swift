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
        v.adjustsFontSizeToFitWidth = true
        v.text = "診断結果: 心療内科"
        v.textColor = UIColor.appColor(.character)
        v.font = UIFont(name: "GillSans-UltraBold", size: 24)
        contentView.addSubview(v)
        return v
    }()
    
    lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.adjustsFontSizeToFitWidth = true
        v.textColor = UIColor.appColor(.character)
        v.font = UIFont(name: "GillSans-UltraBold", size: 20)
        v.text = "あなたは心だけでなく体にも不調がでています。心療内科で治療を受けましょう"
        contentView.addSubview(v)
        return v
    }()
    
    lazy var goNextButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("次へ", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 28)
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 20
        v.addTarget(self, action: #selector(goNextButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    let questionViewController = QuestionViewController()
    let resultDetailViewController = ResultDetailViewController()
    
    
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
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.width.equalTo(contentView.snp.width).offset(-30)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        goNextButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(80)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(80)
            make.width.equalTo(220)
        }
    }
    
    
}

extension ResultViewController {
    @objc func goNextButtonTapped() {
        questionViewController.resetQuestionNumber()
        self.navigationController?.pushViewController(resultDetailViewController, animated: true)
    }
    @objc func backButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

