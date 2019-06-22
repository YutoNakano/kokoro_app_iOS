//
//  SignUpViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/22.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import LTMorphingLabel

final class SignUpViewController: ViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    
    lazy var titleLabel: LTMorphingLabel = {
        let v = LTMorphingLabel()
        v.text = "心の案内所"
        v.morphingEffect = .scale
        v.font = UIFont(name: "GillSans-UltraBold", size: 36)
        view.addSubview(v)
        return v
    }()
    
    lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.text = "ニックネームを入力してください"
        v.font = UIFont(name: "GillSans", size: 22)
        view.addSubview(v)
        return v
    }()
    
    lazy var textField: UITextField = {
        let v = UITextField()
        v.font = UIFont(name: "GillSans", size: 28)
        view.addSubview(v)
        return v
    }()
    
    lazy var singUpButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("サインイン", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 28)
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 20
        v.addTarget(self, action: #selector(singUpButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    override func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.top.equalTo(300)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(textField.snp.left)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        textField.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.width.equalTo(screenWidth - 40)
            make.height.equalTo(90)
        }
        singUpButton.snp.makeConstraints { make in
            make.centerX.equalTo(textField.snp.centerX)
            make.height.equalTo(90)
            make.width.equalTo(textField.snp.width)
            make.top.equalTo(textField.snp.top).offset(30)
        }
    }
    
}


extension SignUpViewController {
    @objc func singUpButtonTapped() {
        handle = Auth.auth().addIDTokenDidChangeListener { auth, user in
            if let user = user {
                
            } else {
                
            }
        }
    }
}

