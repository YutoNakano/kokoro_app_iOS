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
    case yesPink = "DE8892"
    case subPink = "FAC5D4"
    case noBlue = "4996E9"
    case gray = "A0A2A2"
    case background = "F4F4F5"
    case lightGray = "DEDADA"
    case navbar = "FEFFFF"
    case lineGreen = "50B535"
    case alartRed = "FD5105"
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
