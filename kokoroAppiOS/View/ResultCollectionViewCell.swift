//
//  ResultCollectionViewCell.swift
//  Interview100
//
//  Created by 中野湧仁 on 2019/06/19.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit


final class ResultCollectionViewCell: UICollectionViewCell {
    
//    let screenWidth = UIScreen.main.bounds.width
    lazy var questionIndexLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont(name: "GillSans-UltraBold", size: 28)
        v.text = "2:"
        contentView.addSubview(v)
        return v
    }()
    lazy var questionLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.text = "aaaaaaaaaaaaaaaaa?"
        v.font = UIFont(name: "GillSans-UltraBold", size: 28)
        contentView.addSubview(v)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
    }
    
    func makeConstraints() {
        questionIndexLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        questionLabel.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.centerY.equalTo(questionIndexLabel.snp.centerY)
            make.left.equalTo(questionIndexLabel.snp.right).offset(30)
        }
    }
}
