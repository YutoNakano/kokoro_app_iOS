//
//  QuestionTitleView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import SnapKit
import UIKit


final class QuestionContentView: View {
    
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.text = "質問1:お腹すいてますか?"
        v.font = UIFont(name: "GillSans-UltraBold", size: 20)
        v.numberOfLines = 0
        addSubview(v)
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
    
    override func setup() {
        backgroundColor = UIColor.white
    }
    
    override func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(140)
        }
    }
}
