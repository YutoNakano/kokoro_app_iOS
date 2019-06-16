//
//  TopViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit

final class TopViewController: ViewController {
    
    let questionViewController = QuestionViewController()
    
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.text = "心の診療所"
        v.font = UIFont(name: "GillSans-UltraBold", size: 36)
        view.addSubview(v)
        return v
    }()
    
    lazy var startButton: UIButton = {
        let v = UIButton()
        v.setTitle("START", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans", size: 28)
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 15
        v.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    override func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(140)
        }
        startButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Session.send(QuestionResponse.SearchRepositories()) { result in
//            switch result {
//            case .success(let response):
//                print(response)
//            case .failure(let error):
//                print(error)
//            }
//        }
//
//
//        Session.send(ResultResponse.SearchRepositories()) { result in
//            switch result {
//            case .success(let response):
//                print(response)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.white
    }
    
}


extension TopViewController {
    @objc func startButtonTapped() {
        navigationController?.pushViewController(questionViewController, animated: true)
    }
}

