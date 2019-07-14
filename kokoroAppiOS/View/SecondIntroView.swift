//
//  SecondIntroView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/07/10.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit

final class SecondIntroView: UIView {
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.appColor(.yesPink)
        addSubview(v)
        return v
    }()
    
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.textColor = UIColor.appColor(.yesPink)
        v.textAlignment = .center
        v.text = "過去の診断結果を\n振り返ることもできます。"
        v.font = UIFont(name: "GillSans-UltraBold", size: 22)
        addSubview(v)
        return v
    }()
    
    lazy var clockImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "clock"))
        contentView.addSubview(v)
        return v
    }()
    
    lazy var desctiptionLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.textColor = UIColor.appColor(.yesPink)
        v.textAlignment = .center
        v.text = "過去の診断結果や、その時に記したメモを振り返り、\n自分の心理状態を客観的に把握しましょう。"
        v.font = UIFont(name: "GillSans-Bold", size: 14)
        addSubview(v)
        return v
    }()
    
    lazy var charactorWhiteView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.appColor(.background)
        v.layer.cornerRadius = 10
        contentView.addSubview(v)
        return v
    }()
    
    lazy var charactorImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "charactor"))
        charactorWhiteView.addSubview(v)
        return v
    }()
    
    let screenHeight = UIScreen.main.bounds.height
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = UIColor.appColor(.background)
    }
    
    func makeConstraints() {
        charactorWhiteView.snp.makeConstraints { make in
            make.height.equalTo(220)
            make.width.equalTo(110)
            make.centerX.equalToSuperview()
            make.top.equalTo(screenHeight / 6)
        }
        contentView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(screenHeight / 2)
        }
        clockImageView.snp.makeConstraints { make in
            make.bottom.equalTo(charactorWhiteView.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        charactorImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-7)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(68)
        }
        desctiptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
    }
}
