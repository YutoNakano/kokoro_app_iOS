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
    
    lazy var titleLabel: LTMorphingLabel = {
        let v = LTMorphingLabel()
        v.numberOfLines = 0
        v.morphingEffect = .scale
        v.text = "あなたは心療内科に行くことをオススメします"
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
    
    override func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(140)
        }
    }
    
    
}

extension ResultViewController {
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

