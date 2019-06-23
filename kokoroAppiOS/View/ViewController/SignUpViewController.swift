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

final class SignUpViewController: ViewController {
    
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
//        paddingView.backgroundColor = UIColor.appColor(.subPink)
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
    
    override func makeConstraints() {
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
        
        UserManager.shared.signUp(withName: name) { result in
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


class KRProgressHUDAppearance {
    /// HUDのスタイル.
    public var style = KRProgressHUDStyle.white
    /// マスクタイプ
    public var maskType = KRProgressHUDMaskType.custom(color: UIColor.appColor(.subPink))
    /// ローディングインジケータのグラデーションカラー
    public var activityIndicatorColors = [UIColor]([.black, .lightGray])
    /// ラベルのフォント
    public var font = UIFont.systemFont(ofSize: 13)
    /// HUDのセンター位置
    public var viewCenterPosition = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    /// HUDの表示時間.
    public var duration = Double(1.0)
}


