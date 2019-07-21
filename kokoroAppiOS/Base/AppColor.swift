//
//  AppColor.swift
//  practice_Mousou
//
//  Created by 中野湧仁 on 2019/03/31.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit

public enum AppColorType: String {
    
    case white = "FFFFFF"
    case black = "000000"
    case character = "5B5355"
    case yesPink = "DD78A4"
    case subPink = "DE8892"
    case noBlue = "ABBEE9"
    case gray = "ABBEE8"
    case background = "A0FAEC"
    case lightGray = "DEDADA"
    case navbar = "FEFFFF"
    case lineGreen = "50B535"
    case alartRed = "FD5105"
    case twitterBlue = "72B4E1"
}

extension UIColor {
    public static func appColor(_ type: AppColorType, alpha:CGFloat? = nil) -> UIColor {
        if let alpha = alpha {
            return UIColor(hex: type.rawValue).withAlphaComponent(alpha)
        } else {
            return UIColor(hex: type.rawValue)
        }
    }
}
