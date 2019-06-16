//
//  QuestionViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit

final class QuestionViewController: ViewController {
    
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.text = "質問1:お腹すいてますか?"
        v.font = UIFont(name: "GillSans-UltraBold", size: 20)
        v.numberOfLines = 0
        view.addSubview(v)
        return v
    }()
    
    lazy var yesButton: UIButton = {
        let v = UIButton()
        v.setTitle("YES", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 20)
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 15
        view.addSubview(v)
        return v
    }()
    
    lazy var noButton: UIButton = {
        let v = UIButton()
        v.setTitle("NO", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 20)
        v.backgroundColor = UIColor.appColor(.noBlue)
        v.layer.cornerRadius = 15
        view.addSubview(v)
        return v
    }()
    
    override func setupView() {
        view.backgroundColor = UIColor.white
    }
    
    override func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(140)
        }
        yesButton.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.right.bottom.equalToSuperview().offset(-40)
        }
        noButton.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(40)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    
    
    
}
