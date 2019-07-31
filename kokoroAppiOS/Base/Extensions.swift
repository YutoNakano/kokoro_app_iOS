//
//  Extensions.swift
//  Learning
//
//  Created by Playground, Inc. on 2018/08/02.
//  Copyright © 2018年 Engineer. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(hex: String, alpha: CGFloat) {
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}


extension UIImage {
    func croppingToCenterSquare() -> UIImage {
        let cgImage = self.cgImage!
        var newWidth = CGFloat(cgImage.width)
        var newHeight = CGFloat(cgImage.height)
        if newWidth > newHeight {
            newWidth = newHeight
        } else {
            newHeight = newWidth
        }
        let x = (CGFloat(cgImage.width) - newWidth)/2
        let y = (CGFloat(cgImage.height) - newHeight)/2
        let rect = CGRect(x: x, y: y, width: newWidth, height: newHeight)
        let croppedCGImage = cgImage.cropping(to: rect)!
        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: self.imageOrientation)
    }
}

// 文字列をURLに変換
extension String {
    var url: URL? {
        return URL(string: self)
    }
}


extension UIButton {
    
    convenience init(normal: String? = nil, selected: String? = nil, target: Any?, action: Selector) {
        self.init(frame: .zero)
        if let named = normal {
            let image = UIImage(named: named, in: Bundle(for: UIView.self), compatibleWith: nil)
            self.setImage(image, for: .normal)
            self.setImage(image, for: [.normal, .highlighted])
        }
        if let named = selected {
            let image = UIImage(named: named, in: Bundle(for: UIView.self), compatibleWith: nil)
            self.setImage(image, for: .selected)
            self.setImage(image, for: [.selected, .highlighted])
        }
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    convenience init(text: String, font: UIFont, textColor: UIColor, target: Any?, action: Selector) {
        self.init(frame: .zero)
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(textColor, for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
}


enum FadeType: TimeInterval {
    case
    Normal = 0.2,
    Slow = 1.0
}

extension UILabel {
    
    func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil) {
        fadeIn(duration: type.rawValue, completed: completed)
    }
    
    func fadeIn(duration: TimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: duration,
                                   animations: {
                                    self.alpha = 1
        }) { finished in
            completed?()
        }
    }
    func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil) {
        fadeOut(duration: type.rawValue, completed: completed)
    }
    func fadeOut(duration: TimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
        UIView.animate(withDuration: duration
            , animations: {
                self.alpha = 0
        }) { [weak self] finished in
            self?.isHidden = true
            self?.alpha = 1
            completed?()
        }
    }
}
