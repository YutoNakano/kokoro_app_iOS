//
//  TopCharactorView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/07/31.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit

enum CharactorImageState: String {
    case normal = "charactor"
    case closeEye = "charactor_eye_close"
    case smallNormal = "charactor_small"
    case smallCloseEye = "charactor_eye_close_small"
}

final class TopCharactorView: UIView {
    
    lazy var charactorDescriptionLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 4
        v.adjustsFontSizeToFitWidth = true
        v.textAlignment = .center
        v.font = UIFont(name: "RoundedMplus1c-Medium", size: 22)
        v.textColor = UIColor.appColor(.character)
        addSubview(v)
        return v
    }()
    
    lazy var charactorImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: CharactorImageState.normal.rawValue))
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = .zero
        v.layer.shadowOpacity = 0.3
        v.layer.shadowRadius = 4
        addSubview(v)
        return v
    }()
    
    var timerCount = 0
    let screenWidth = UIScreen.main.bounds.width
    var nomalToCloseEyeImageTimer: Timer?
    var closeEyeToNormalImageTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeConstraints() {
        charactorDescriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(screenWidth - 80)
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        charactorImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension TopCharactorView {
    func setUpTimer() {
        nomalToCloseEyeImageTimer = Timer.scheduledTimer(timeInterval: setTimeInterval(), target: self, selector: #selector(normalToCloseEyeTimerAction), userInfo: nil, repeats: true)
    }
    
    func setTimeInterval() -> TimeInterval {
        return TimeInterval(Float.random(in: 4...6))
    }
    func charactorAnimation() {
        UIView.animate(withDuration: 2.0, delay: 0.3, options: [.repeat,.autoreverse], animations: {
            self.charactorImageView.center.y += 25
        }) { _ in
            self.charactorImageView.center.y -= 25
        }
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
    func invalidateTimer() {
        if let toColseEyeTimer = nomalToCloseEyeImageTimer, let toNomalTimer = closeEyeToNormalImageTimer {
            toColseEyeTimer.invalidate()
            toNomalTimer.invalidate()
        }
    }
}

