//
//  ViewController.swift
//  practice_Mousou
//
//  Created by 中野湧仁 on 2019/03/31.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
public class UIViewController: UIViewController {
    
    public override func loadView() {
        super.loadView()
        setupNavigation()
        setupView()
        makeConstraints()
        
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // NavigationController の設定
    public func setupNavigation() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
    }
    
    // 自身のviewの設定
    public func setupView() {
        view.backgroundColor = UIColor.appColor(.background)
    }
    
    public func makeConstraints() { } // レイアウトに制約を付加
}
