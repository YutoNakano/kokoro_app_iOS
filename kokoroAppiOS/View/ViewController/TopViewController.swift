//
//  TopViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import LTMorphingLabel
import Lottie

protocol TopViewControllerDelegate: class {
    func resetQuestionCount()
}

final class TopViewController: UIViewController {
    
    lazy var charactorImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "charactor"))
        view.addSubview(v)
        return v
    }()
    
    lazy var startButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("診断を始める", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 28)
        v.titleLabel?.textColor = UIColor.white
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 20
        v.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    lazy var watchHistoryButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("過去の診断結果", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 28)
        v.backgroundColor = UIColor.appColor(.gray)
        v.layer.cornerRadius = 20
        v.addTarget(self, action: #selector(watchHistoryButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    let questionViewController = QuestionViewController()
    let historyViewController = HistoryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charactorAnimation()
        let presenter = QuestionPresenter(view: questionViewController)
        questionViewController.inject(presenter: presenter)
        
        let user = Auth.auth().currentUser; if let user = user {
            let uid = user.uid
            print(uid)
        }
    }
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.appColor(.background)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
    }
    
    func makeConstraints() {
        charactorImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(140)
        }
        startButton.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(80)
        }
        watchHistoryButton.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(startButton.snp.bottom).offset(60)
        }
    }
    
}


extension TopViewController {
    @objc func startButtonTapped() {
        questionViewController.resetQuestionNumber()
        navigationController?.pushViewController(questionViewController, animated: true)
    }
    @objc func watchHistoryButtonTapped() {
        navigationController?.pushViewController(historyViewController, animated: true)
    }
    
    func charactorAnimation() {
        UIView.animate(withDuration: 2.0, delay: 0.5, options: [.repeat,.autoreverse], animations: {
                self.charactorImageView.center.y += 30
            }) { _ in
                self.charactorImageView.center.y -= 30
        }
    }
}

