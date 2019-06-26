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
import KRProgressHUD

final class SignUpViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    
    
    private var name: String = "" {
        didSet {
            singUpButton.isEnabled = !name.isEmpty
        }
    }
    
    lazy var titleImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "logo"))
        view.addSubview(v)
        return v
    }()
    
    lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.text = "ニックネームを入力してください"
        v.textColor = UIColor.appColor(.character)
        v.font = UIFont(name: "GillSans", size: 15)
        view.addSubview(v)
        return v
    }()
    
    lazy var textField: UITextField = {
        let v = UITextField()
        v.font = UIFont(name: "GillSans", size: 28)
        v.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        v.layer.cornerRadius = 5
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        v.leftView = paddingView
        v.leftViewMode = .always
        v.backgroundColor = UIColor.appColor(.navbar)
        v.delegate = self
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
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
    }
    
    func setupView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
        view.backgroundColor = UIColor.appColor(.background)
    }
    
    func makeConstraints() {
        titleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(100)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-20)
            make.left.equalTo(textField.snp.left)
            make.width.equalTo(screenWidth)
        }
        textField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalTo(titleImageView.snp.centerX)
            make.width.equalTo(screenWidth - 50)
        }
        singUpButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(80)
            make.centerX.equalTo(textField.snp.centerX)
            make.height.equalTo(80)
            make.width.equalTo(220)
        }
    }
    
}


extension SignUpViewController {
    @objc func singUpButtonTapped() {
        KRProgressHUD.show()
        let user_id = "\(name)_\(Int.random(in: 0...9999).description)"
        UserManager.shared.signUp(user_id: user_id,withName: name) { result in
            KRProgressHUD.dismiss()
            print(result)
        }
    }
    @objc func editingChanged(_ textField: UITextField) {
        name = textField.text ?? ""
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


