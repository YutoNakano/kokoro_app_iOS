//
//  QuestionTitleView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import SnapKit
import UIKit
import LTMorphingLabel

final class QuestionContentView: UIView {
    
    let screenWidth = UIScreen.main.bounds.width
    var viewController: QuestionViewController?
    var questionTitle: String? {
        didSet {
            self.setModel()
        }
    }
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.appColor(.navbar)
        v.layer.cornerRadius = 10
        v.layer.shadowOpacity = 0.1
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        v.layer.shadowRadius = 10
        addSubview(v)
        return v
    }()
    
    lazy var questionLabel: UILabel = {
        let v = UILabel()
        v.textColor = UIColor.appColor(.character)
        v.text = "質問"
        v.font = UIFont(name: "GillSans-UltraBold", size: 20)
        contentView.addSubview(v)
        return v
    }()
    
    lazy var questionNumberLabel: LTMorphingLabel = {
        let v = LTMorphingLabel()
        v.numberOfLines = 0
        v.textColor = UIColor.appColor(.character)
        v.adjustsFontSizeToFitWidth = true
        v.font = UIFont(name: "GillSans-UltraBold", size: 28)
        v.morphingEffect = .scale
        contentView.addSubview(v)
        return v
    }()
    
    lazy var maxNunberLabel: UILabel = {
        let v = UILabel()
        v.textColor = UIColor.appColor(.character)
        v.text = " /10"
        v.font = UIFont(name: "GillSans-UltraBold", size: 20)
        contentView.addSubview(v)
        return v
    }()
    
    lazy var questionTitleLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.text = ""
        v.textColor = UIColor.appColor(.character)
        v.font = UIFont(name: "GillSans-UltraBold", size: 28)
        v.lineBreakMode = .byWordWrapping
        v.sizeToFit()
        contentView.addSubview(v)
        return v
    }()
    
    
    lazy var underLineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.appColor(.character, alpha: 0.4)
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
        setModel()
        questionTitleLabel.fadeIn(type: .Normal)
    }
    
    func setModel() {
        guard var number = viewController?.questionNumber else { return }
        number += 1
        questionNumberLabel.text = number.description
        guard let title = questionTitle else { return }
        questionTitleLabel.text = title
    }
    
    func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(80)
            make.height.equalTo(250)
            make.width.equalTo(screenWidth - 30)
            make.centerX.equalToSuperview()
        }
        questionLabel.snp.makeConstraints { make in
            make.width.equalTo(43)
            make.left.equalTo(18)
            make.top.equalTo(20)
        }
        questionNumberLabel.snp.makeConstraints { make in
//            make.width.equalTo(38)
            make.height.equalTo(30)
            make.top.equalTo(questionLabel.snp.top).offset(-5)
            make.left.equalTo(questionLabel.snp.right).offset(7)
        }
        maxNunberLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.left.equalTo(questionNumberLabel.snp.right).offset(3)
            make.top.equalTo(questionLabel.snp.top)
        }
        underLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(screenWidth - 50)
            make.top.equalTo(questionLabel.snp.bottom).offset(6)
            make.left.equalTo(questionLabel.snp.left)
        }
        questionTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(screenWidth - 70)
            make.centerX.equalToSuperview()
            make.top.equalTo(questionNumberLabel.snp.bottom).offset(40)
        }
    }
}

