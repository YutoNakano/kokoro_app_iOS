//
//  ResultCollectionViewCell.swift
//  Interview100
//
//  Created by 中野湧仁 on 2019/06/19.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit


final class ResultCollectionViewCell: UICollectionViewCell {
    
    lazy var questionIndexLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont(name: "RoundedMplus1c-Medium", size: 20)
        v.textColor = UIColor.appColor(.character)
        v.adjustsFontSizeToFitWidth = true
        v.text = "2,"
        contentView.addSubview(v)
        return v
    }()
    lazy var questionLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.text = "今現在体にも不調が出ていますか?"
        v.adjustsFontSizeToFitWidth = true
        v.textColor = UIColor.appColor(.character)
        v.font = UIFont(name: "RoundedMplus1c-Medium", size: 20)
        contentView.addSubview(v)
        return v
    }()
    
    lazy var answerLabel: UILabel = {
        let v = UILabel()
        v.text = "A: YES"
        v.textColor = UIColor.appColor(.yesPink)
        v.font = UIFont(name: "RoundedMplus1c-Medium", size: 20)
        v.adjustsFontSizeToFitWidth = true
        contentView.addSubview(v)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = UIColor.appColor(.navbar)
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        layer.shadowRadius = 10
    }
    
    func makeConstraints() {
        questionIndexLabel.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        questionLabel.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.height.equalTo(110)
            make.centerY.equalTo(questionIndexLabel.snp.centerY)
            make.left.equalToSuperview().offset(70)
        }
        answerLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-3)
        }
    }
}
