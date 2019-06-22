//
//  ResultViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import LTMorphingLabel


final class ResultViewController: ViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
//        v.morphingEffect = .scale
        v.text = "あなたは心療内科に行くことをオススメします!"
        v.font = UIFont(name: "GillSans-UltraBold", size: 36)
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    override func loadView() {
        super.loadView()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    override func setupView() {
        view.backgroundColor = UIColor.appColor(.background)
    }
    
    override func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(screenWidth - 30)
            make.centerX.equalToSuperview()
            make.top.equalTo(80)
        }
    }
    
    
}

extension ResultViewController {
    @objc func backButtonTapped() {
       self.navigationController?.popToRootViewController(animated: true)
    }
}

