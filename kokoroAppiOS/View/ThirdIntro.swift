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
    
    lazy var charactorImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "charactor"))
        addSubview(v)
        return v
    }()
    
    lazy var twitterLoginButton: UIButton = {
        let v = UIButton()
        v.setTitle("Twitter登録/ログイン", for: .normal)
        v.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 18)
        v.tintColor = UIColor.appColor(.white)
        v.layer.cornerRadius = 12
        v.backgroundColor = UIColor.appColor(.twitterBlue)
        v.addTarget(self, action: #selector(TwitterloginButtonTapped), for: .touchUpInside)
        addSubview(v)
        return v
    }()
    
    weak var delegate: ThirdIntroViewDelegate?
    var nomalToCloseEyeImageTimer: Timer?
    var closeEyeToNormalImageTimer: Timer?
    var timerCount = 0
    var charactorState = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        makeConstraints()
        setUpTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = UIColor.appColor(.yesPink)
    }
    
    func makeConstraints() {
        charactorImageView.snp.makeConstraints { make in
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
    
    func setUpTimer() {
        nomalToCloseEyeImageTimer = Timer.scheduledTimer(timeInterval: setTimeInterval(), target: self, selector: #selector(normalToCloseEyeTimerAction), userInfo: nil, repeats: true)
    }
    
    func setTimeInterval() -> TimeInterval {
        return TimeInterval(Float.random(in: 4...6))
    }
    
    @objc func normalToCloseEyeTimerAction() {
        charactorImageView.image = UIImage(named: CharactorImageState.closeEye.rawValue)
        // 画像をnomalに戻すTimer
        closeEyeToNormalImageTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(closeEyeToNormalTimerAction), userInfo: nil, repeats: true)
    }
    
    @objc func closeEyeToNormalTimerAction() {
        charactorImageView.image = UIImage(named: CharactorImageState.normal.rawValue)
        if let toNomalTimer = closeEyeToNormalImageTimer {
            toNomalTimer.invalidate()
        }
    }
}

extension ThirdIntroView {
    @objc func TwitterloginButtonTapped() {
        if let toColseEyeTimer = nomalToCloseEyeImageTimer, let toNomalTimer = closeEyeToNormalImageTimer {
            toColseEyeTimer.invalidate()
            toNomalTimer.invalidate()
        }
        delegate?.twitterLoginButtonTapped()
    }
}
