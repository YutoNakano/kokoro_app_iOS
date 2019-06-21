//
//  MaterialButton.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/21.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit


final class MaterialButton: UIButton {
    
    private let tapEffectView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(ovalIn: tapEffectView.bounds).cgPath
        tapEffectView.layer.addSublayer(shapeLayer)
        tapEffectView.isHidden = true
        
        addSubview(tapEffectView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let point = touches.first?.location(in: self) {
            tapEffectView.frame.origin = point
            
            tapEffectView.alpha = 0.3
            tapEffectView.isHidden = false
            tapEffectView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            UIView.animate(withDuration: 0.5, animations:  {
                self.tapEffectView.alpha = 0
                self.tapEffectView.transform = CGAffineTransform(scaleX: 200, y: 200)
            }) { finished in
                self.tapEffectView.isHidden = true
                self.tapEffectView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            }
        }
    
}


