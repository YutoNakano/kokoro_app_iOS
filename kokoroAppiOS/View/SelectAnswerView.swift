//
//  SelectButtonView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import SnapKit
import UIKit


final class SelectAnserView: UIView {

    lazy var yesButton: UIButton = {
        let v = UIButton()
        v.setTitle("YES", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 20)
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 15
        addSubview(v)
        return v
    }()

    lazy var noButton: UIButton = {
        let v = UIButton()
        v.setTitle("NO", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 20)
        v.backgroundColor = UIColor.appColor(.noBlue)
        v.layer.cornerRadius = 15
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
    
    func setup() {
        backgroundColor = UIColor.white
    }

    func makeConstraints() {
        yesButton.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.right.bottom.equalToSuperview().offset(-40)
        }
        noButton.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(40)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}
