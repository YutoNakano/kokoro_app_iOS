//
//  ThirdIntroView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/07/10.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit

protocol ThirdIntroViewDelegate: class {
    func twitterLoginButtonTapped()
}

final class ThirdIntroView: UIView {
    
    lazy var logoImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "logo"))
        addSubview(v)
        return v
    }()
    
    lazy var twitterLoginButton: UIButton = {
        let v = UIButton()
        v.setTitle("Twitter登録/ログイン", for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-Bold", size: 16)
        v.tintColor = UIColor.appColor(.white)
        v.layer.cornerRadius = 12
        v.backgroundColor = UIColor.appColor(.twitterBlue)
        v.addTarget(self, action: #selector(TwitterloginButtonTapped), for: .touchUpInside)
        addSubview(v)
        return v
    }()
    
    weak var delegate: ThirdIntroViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = UIColor.appColor(.yesPink)
    }
    
    func makeConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(110)
            make.centerX.equalToSuperview()
        }
        twitterLoginButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(210)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-240)
        }
    }
}

extension ThirdIntroView {
    @objc func TwitterloginButtonTapped() {
        delegate?.twitterLoginButtonTapped()
    }
}
