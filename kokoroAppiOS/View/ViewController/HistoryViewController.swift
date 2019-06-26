//
//  HistoryViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/21.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit

final class HistoryViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    
    lazy var historyCollectionView: HistoryDetailCollectionView = {
        let v = HistoryDetailCollectionView()
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func makeConstraints() {
        historyCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func setupView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
    }
    
}

extension HistoryViewController {
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
