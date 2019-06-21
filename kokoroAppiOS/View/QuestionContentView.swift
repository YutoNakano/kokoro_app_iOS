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
    
    lazy var questionNumberLabel: LTMorphingLabel = {
        let v = LTMorphingLabel()
        v.numberOfLines = 0
        v.font = UIFont(name: "GillSans-UltraBold", size: 22)
        v.morphingEffect = .scale
        addSubview(v)
        return v
    }()
    
    lazy var questionTitleLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.text = ""
        v.font = UIFont(name: "GillSans-UltraBold", size: 28)
//        v.morphingEffect = .scale
        v.lineBreakMode = .byWordWrapping
        v.sizeToFit()
        addSubview(v)
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
        backgroundColor = UIColor.white
        setModel()
        questionTitleLabel.fadeIn(type: .Normal)
    }
    
    func setModel() {
        guard var number = viewController?.questionNumber else { return }
        number += 1
        questionNumberLabel.text = "質問\(number.description)"
        guard let title = questionTitle else { return }
        questionTitleLabel.text = title
    }
    
    func makeConstraints() {
        questionNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.width.equalTo(100)
            make.left.equalTo(18)
        }
        questionTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(screenWidth - 90)
            make.centerX.equalToSuperview()
            make.top.equalTo(questionNumberLabel.snp.bottom).offset(20)
        }
    }
}

