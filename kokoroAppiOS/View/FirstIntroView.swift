//
//  FirstIntroView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/07/10.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit

final class FirstIntroView: UIView {
    
    lazy var desctiptionLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.textColor = UIColor.appColor(.character)
        v.text = "33333333333333333"
        v.font = UIFont(name: "GillSans", size: 22)
        addSubview(v)
        return v
    }()
    
    lazy var charactorImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "charactor"))
        addSubview(v)
        return v
    }()
    
    var viewController: SignUpViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = UIColor.appColor(.background)
    }
    
    func makeConstraints() {
        desctiptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(50)
            make.height.equalTo(200)
        }
        charactorImageView.snp.makeConstraints { make in
            make.top.equalTo(desctiptionLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
        }
    }
}
