//
//  SelectButtonView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import SnapKit
import UIKit


protocol SelectAnserViewDelegate: class {
    func getQuestionNumber(number: Int)
}

final class SelectAnserView: UIView {
    
    lazy var timeLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.font = UIFont(name: "GillSans-UltraBold", size: 30)
        addSubview(v)
        return v
    }()

    lazy var goButton: UIButton = {
        let v = UIButton()
        v.setTitle("次へ", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 20)
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        v.layer.cornerRadius = 15
        addSubview(v)
        return v
    }()

    lazy var backButton: UIButton = {
        let v = UIButton()
        v.setTitle("TOPに戻る", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 17)
        v.backgroundColor = UIColor.appColor(.noBlue)
        v.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        v.layer.cornerRadius = 15
        addSubview(v)
        return v
    }()

    var viewController: QuestionViewController?
    weak var delegate: SelectAnserViewDelegate?
    var timer: Timer?
    
    let resultViewController = ResultViewController()
    private var limitNumber: Int = 10
    var questionCount: Int = 0
    var timeCount: Int = 0
    
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
    }

    func makeConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        goButton.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.right.bottom.equalToSuperview().offset(-40)
        }
        backButton.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(40)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}

extension SelectAnserView {
    @objc func goButtonTapped() {
        timer?.invalidate()
        questionCount += 1
        delegate?.getQuestionNumber(number: questionCount)
        guard questionCount < limitNumber else {
            timer?.invalidate()
            viewController?.navigationController?.pushViewController(resultViewController, animated: true)
         return
        }
        viewController?.reload()
        startTimer()
    }
    @objc func backButtonTapped() {
        timer?.invalidate()
        questionCount = 0
        viewController?.navigationController?.popViewController(animated: true)
        
    }
    func startTimer() {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onUpdate(timer:)), userInfo: nil, repeats: true)
    }
    @objc func onUpdate(timer: Timer) {
        timeCount += 1
//        let now = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "mm:ss.SSS"
//        print(formatter.string(from: now))
////        let str = String(format: "%.0f", questionCount)
//        timeLabel.text = questionCount.description
//        print(questionCount)
    }
}
