//
//  TopMenuButtonView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/07/31.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit

protocol TopMenuButtonViewDelegate: class {
    func didTapStartButton()
    func didTapWatchHistoryButton()
    func didTapLineButton()
}

final class TopMenuButtonView: UIView {
    
    lazy var startButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("診断する", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 24)
        v.titleLabel?.textColor = UIColor.white
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 20
        v.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        addSubview(v)
        return v
    }()
    
    lazy var watchHistoryButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("過去の\n診断結果", for: .normal)
        v.titleLabel?.textAlignment = .center
        v.titleLabel?.numberOfLines = 2
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 24)
        v.backgroundColor = UIColor.appColor(.gray)
        v.layer.cornerRadius = 20
        v.addTarget(self, action: #selector(watchHistoryButtonTapped), for: .touchUpInside)
        addSubview(v)
        return v
    }()
    
    lazy var lineButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("LINE@", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 16)
        v.backgroundColor = UIColor.appColor(.lineGreen)
        v.layer.cornerRadius = 30
        v.addTarget(self, action: #selector(lineButtonTapped), for: .touchUpInside)
        addSubview(v)
        return v
    }()
    
    weak var delegate: TopMenuButtonViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        makeConstraints()
    }
    
    func makeConstraints() {
        startButton.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(80)
            make.bottom.equalToSuperview().offset(-110)
            make.right.equalToSuperview().offset(-40)
        }
        watchHistoryButton.snp.makeConstraints { make in
            make.size.equalTo(startButton.snp.size)
            make.centerY.equalTo(startButton.snp.centerY)
            make.left.equalToSuperview().offset(40)
        }
        lineButton.snp.makeConstraints { make in
            make.size.equalTo(68)
            make.bottom.right.equalToSuperview().offset(-25)
        }
    }
}

extension TopMenuButtonView {
    @objc func startButtonTapped() {
        delegate?.didTapStartButton()
    }
    @objc func watchHistoryButtonTapped() {
        delegate?.didTapWatchHistoryButton()
    }
    @objc func lineButtonTapped() {
        delegate?.didTapLineButton()
    }
}
