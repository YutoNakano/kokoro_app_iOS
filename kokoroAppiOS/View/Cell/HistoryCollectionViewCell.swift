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
    
    
    lazy var diagnosticTime: UILabel = {
        let v = UILabel()
        v.font = UIFont(name: "GillSans-UltraBold", size: 16)
        v.text = "3/24 3:24"
        v.textColor = UIColor.appColor(.character)
        contentView.addSubview(v)
        return v
    }()
    lazy var resultLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.text = "診断結果:　保健所"
        v.textColor = UIColor.appColor(.character)
        v.font = UIFont(name: "GillSans-UltraBold", size: 20)
        contentView.addSubview(v)
        return v
    }()
    
    lazy var goNextImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "go"))
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
        backgroundColor = UIColor.appColor(.navbar)
        
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        layer.shadowRadius = 10
    }
    
    func makeConstraints() {
        diagnosticTime.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(10)
        }
        resultLabel.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(80)
        }
        goNextImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
    }
}
