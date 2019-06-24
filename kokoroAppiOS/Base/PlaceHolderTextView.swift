//
//  PlaceHolderTextView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/24.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit

class PlaceHolderTextView: UITextView {
    
    var placeHolder: String = "" {
        didSet {
            self.placeHolderLabel.text = self.placeHolder
            self.placeHolderLabel.sizeToFit()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var placeHolderLabel: UILabel = {
        let v = UILabel(frame: CGRect(x: 6.0, y: 6.0, width: 0.0, height: 0.0))
        v.lineBreakMode = .byWordWrapping
        v.numberOfLines = 0
        v.font = self.font
        v.textColor = UIColor(red: 0.0,
                                                  green: 0.0,
                                                  blue: 0.0980392,
                                                  alpha: 0.22)
        v.backgroundColor = .clear
        self.addSubview(v)
        return v
    }()
    
    func changeVisiblePlaceHolder() {
        if self.placeHolder.isEmpty || !self.text.isEmpty {
            self.placeHolderLabel.alpha = 0.0
        } else {
            self.placeHolderLabel.alpha = 1.0
        }
    }
    
    func makeConstraints() {
        placeHolderLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
        }
    }
    @objc private func textChanged(notification: NSNotification?) {
        changeVisiblePlaceHolder()
    }
    
}
