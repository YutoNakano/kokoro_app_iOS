//
//  HistoryCollectionViewCell.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/21.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit


final class HistoryCollectionViewCell: UICollectionViewCell {
    
    //    let screenWidth = UIScreen.main.bounds.width
    lazy var resultIndexLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont(name: "GillSans-UltraBold", size: 28)
        v.text = "1,"
        contentView.addSubview(v)
        return v
    }()
    lazy var resultLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.text = "保健所に行ってみてはいかがでしょうか?"
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
        resultIndexLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        resultLabel.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.centerY.equalTo(resultIndexLabel.snp.centerY)
            make.left.equalTo(resultIndexLabel.snp.right).offset(30)
        }
    }
}
