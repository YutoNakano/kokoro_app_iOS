//
//  resultDescriptionCell.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/08/09.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import LTMorphingLabel

//protocol ResultDescriptionDelegate: class {
////    func tapLinkButton()
//}

final class ResultDescriptionCell: UITableViewCell {
    
    lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.adjustsFontSizeToFitWidth = true
        v.textColor = UIColor.appColor(.character)
        v.backgroundColor = UIColor.appColor(.background)
        v.textAlignment = .center
        v.numberOfLines = 0
        v.font = UIFont(name: "RoundedMplus1c-Medium", size: 12)
        v.text = "あなたは心だけでなく体にも不調がでています。心療内科で治療を受けましょう"
        addSubview(v)
        return v
    }()
    
    lazy var linkButton: UIButton = {
        let v = UIButton()
        v.setTitle("こちら", for: .normal)
        v.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 20)
        v.setTitleColor(UIColor.blue, for: .normal)
        v.backgroundColor = UIColor.clear
        addSubview(v)
        return v
    }()
    
//    weak var delegate: ResultDescriptionDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        linkButton.snp.makeConstraints { make in
            make.left.equalTo(descriptionLabel.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
    }
}

extension ResultDescriptionCell {
    
}
