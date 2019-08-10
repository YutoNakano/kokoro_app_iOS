//
//  ResultContentView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/07/03.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import LTMorphingLabel

protocol ResultContentViewDelegate: class {
    func linkButtonTapped(buttonTag: Int)
}

final class ResultContentView: UIView {
    
    let screenWidth = UIScreen.main.bounds.width
    
    var nomalToCloseEyeImageTimer: Timer?
    var closeEyeToNormalImageTimer: Timer?
    var timerCount = 0
    var charactorState = true
    var descriptionStrings = [String]()
    
    let cellTitles = [
        "医療機関については",
        "保健所については",
        "カウンセリングについては"
    ]
    
    
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
    
    lazy var titleLabel: LTMorphingLabel = {
        let v = LTMorphingLabel()
        v.numberOfLines = 0
        v.morphingEffect = .scale
        v.adjustsFontSizeToFitWidth = true
        v.text = "診断結果: 心療内科"
        v.textColor = UIColor.appColor(.character)
        v.font = UIFont(name: "RoundedMplus1c-Medium", size: 24)
        contentView.addSubview(v)
        return v
    }()
    
    lazy var tableView: UITableView = {
        let v = UITableView()
        v.register(ResultDescriptionCell.self, forCellReuseIdentifier: "Cell")
        v.rowHeight = 42
        v.separatorStyle = .none
        v.allowsSelection = false
        v.dataSource = self
        v.delegate = self
        v.backgroundColor = UIColor.appColor(.background)
        addSubview(v)
        return v
    }()
    
    lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.adjustsFontSizeToFitWidth = true
        v.textColor = UIColor.appColor(.character)
        v.textAlignment = .center
        v.font = UIFont(name: "RoundedMplus1c-Medium", size: 16)
        v.text = "あなたは心だけでなく体にも不調がでています。心療内科で治療を受けましょう"
        addSubview(v)
        return v
    }()
    
    lazy var linkButton: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(linkButtonTapped(_:)), for: .touchUpInside)
        v.setTitle("こちら", for: .normal)
        v.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 20)
        v.setTitleColor(UIColor.blue, for: .normal)
        v.backgroundColor = UIColor.clear
        addSubview(v)
        return v
    }()
    
    lazy var charactorImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: CharactorImageState.smallNormal.rawValue))
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = .zero
        v.layer.shadowOpacity = 0.3
        v.layer.shadowRadius = 4
        addSubview(v)
        return v
    }()
    
    weak var delegate: ResultContentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        makeConstraints()
    }
    
    func setup() {
        setUpTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(90)
        }
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.top.equalTo(contentView.snp.bottom).offset(10)
            make.width.equalTo(contentView.snp.width).offset(-20)
        }
        linkButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        charactorImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-110)
        }
        sendSubviewToBack(descriptionLabel)
    }
    
}

extension ResultContentView {
    func charactorAnimation() {
        UIView.animate(withDuration: 2.0, delay: 0.3, options: [.repeat,.autoreverse], animations: {
            self.charactorImageView.center.y += 10
        }) { _ in
            self.charactorImageView.center.y -= 10
        }
    }
    func setUpTimer() {
        nomalToCloseEyeImageTimer = Timer.scheduledTimer(timeInterval: setTimeInterval(), target: self, selector: #selector(normalToCloseEyeTimerAction), userInfo: nil, repeats: true)
    }
    
    func setTimeInterval() -> TimeInterval {
        return TimeInterval(Float.random(in: 4...6))
    }
    
    @objc func normalToCloseEyeTimerAction() {
        charactorImageView.image = UIImage(named: CharactorImageState.smallCloseEye.rawValue)
        // 画像をnomalに戻すTimer
        closeEyeToNormalImageTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(closeEyeToNormalTimerAction), userInfo: nil, repeats: true)
    }
    
    @objc func closeEyeToNormalTimerAction() {
        charactorImageView.image = UIImage(named: CharactorImageState.smallNormal.rawValue)
        if let toNomalTimer = closeEyeToNormalImageTimer {
            toNomalTimer.invalidate()
        }
    }
    @objc func linkButtonTapped(_ sender: UIButton) {
        delegate?.linkButtonTapped(buttonTag: sender.tag)
    }
}

extension ResultContentView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ResultDescriptionCell else { fatalError() }
        cell.descriptionLabel.text = cellTitles[indexPath.row]
        cell.linkButton.addTarget(self, action: #selector(linkButtonTapped(_:)), for: .touchUpInside)
        cell.linkButton.tag = indexPath.row + 1
        return cell
    }
}


extension ResultContentView: UITableViewDelegate {

}
