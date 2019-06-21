//
//  ViewController.swift
//  practice_Mousou
//
//  Created by 中野湧仁 on 2019/03/31.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
public class ViewController: UIViewController {
    
    public override func loadView() {
        super.loadView()
        setupNavigation()
        setupView()
        makeConstraints()
        
    }
    
    // NavigationController の設定
    public func setupNavigation() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
    }
    
    // 自身のviewの設定
    public func setupView() {
        view.backgroundColor = UIColor.appColor(.white)
    }
    
    public func makeConstraints() { } // レイアウトに制約を付加
}
