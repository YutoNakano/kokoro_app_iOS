//
//  TopViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import LTMorphingLabel
import Lottie

final class TopViewController: ViewController {
    
    let questionViewController = QuestionViewController()
    
    lazy var titleLabel: LTMorphingLabel = {
        let v = LTMorphingLabel()
        v.numberOfLines = 0
        v.morphingEffect = .scale
        v.text = "頻出!!面接質問帳"
        v.font = UIFont(name: "GillSans-UltraBold", size: 36)
        view.addSubview(v)
        return v
    }()
    
    lazy var startButton: UIButton = {
        let v = UIButton()
        v.setTitle("START", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans", size: 28)
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 15
        v.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(140)
        }
        startButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(80)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = QuestionPresenter(view: questionViewController)
        questionViewController.inject(presenter: presenter)
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.white
    }
    
}


extension TopViewController {
    @objc func startButtonTapped() {
        navigationController?.pushViewController(questionViewController, animated: true)
    }
}

