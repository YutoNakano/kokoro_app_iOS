//
//  HistoryDetailMemoView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/29.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit

final class HistoryDetailMemoView: UIView {
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.appColor(.navbar)
        v.layer.cornerRadius = 10
        addSubview(v)
        return v
    }()
    
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "MEMO"
        v.font = UIFont(name: "GillSans-Bold", size: 20)
        v.textColor = UIColor.appColor(.subPink)
        contentView.addSubview(v)
        return v
    }()
    
    lazy var memoLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.textColor = UIColor.appColor(.character)
        v.font = UIFont(name: "GillSans", size: 16)
        v.backgroundColor = UIColor.appColor(.navbar)
        contentView.addSubview(v)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = UIColor.appColor(.background)
    }
    
    
    func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.width.equalToSuperview().offset(-20)
            make.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(-20)
        }
        memoLabel.snp.makeConstraints { make in
            make.width.equalTo(contentView.snp.width).offset(-15)
            make.center.equalToSuperview()
        }
    }
    
}
