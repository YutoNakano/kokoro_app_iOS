//
//  SelectButtonView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import SnapKit
import UIKit


final class SelectAnserView: UIView {
    
    lazy var timeLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.textColor = UIColor.appColor(.character)
        v.font = UIFont(name: "GillSans-UltraBold", size: 30)
        addSubview(v)
        return v
    }()

    lazy var yesButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("YES", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 20)
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        v.layer.cornerRadius = 20
        addSubview(v)
        return v
    }()

    lazy var noButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("NO", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 17)
        v.backgroundColor = UIColor.appColor(.noBlue)
        v.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        v.layer.cornerRadius = 20
        addSubview(v)
        return v
    }()

    var viewController: QuestionViewController?
    
    private var limitNumber: Int = 10
    
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
    }

    func makeConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
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

extension SelectAnserView {
    @objc func yesButtonTapped() {
        viewController?.selectedAnswer(selected: .yes)
        validateLimitCount()
    }
    @objc func noButtonTapped() {
        viewController?.selectedAnswer(selected: .no)
        validateLimitCount()
    }
    
    func validateLimitCount() {
        if let number = viewController?.questionNumber {
            guard number < limitNumber else {
                viewController?.goResultVC()
                return
            }
        }
    }
}
