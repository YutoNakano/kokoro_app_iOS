//
//  FirstIntroView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/07/10.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit

final class FirstIntroView: UIView {
    
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
        v.text = "心の案内所は、あなたの心理状況を\n紐解いていくアプリです"
        v.font = UIFont(name: "RoundedMplus1c-Medium", size: 22)
        addSubview(v)
        return v
    }()
    
    lazy var desctiptionLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.textColor = UIColor.appColor(.yesPink)
        v.textAlignment = .center
        v.text = "数個の質問で「心療内科、保健所、精神科、\nカウンセリングどこに行けばよいかわからない」を\n解決することができます。"
        v.font = UIFont(name: "RoundedMplus1c-Regular", size: 14)
        addSubview(v)
        return v
    }()
    
    lazy var charactorImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "kokoro_world"))
        contentView.addSubview(v)
        return v
    }()
    
    let screenHeight = UIScreen.main.bounds.height
    
    var viewController: SignUpViewController?
    
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
        contentView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(screenHeight / 2)
        }
        charactorImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().dividedBy(1)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(80)
        }
        desctiptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
    }
}
