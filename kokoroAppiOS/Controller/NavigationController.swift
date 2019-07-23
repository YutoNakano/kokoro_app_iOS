//
//  NavigationController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/22.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import UIKit

final class NavigationController: UINavigationController {
    static func build() -> NavigationController {
        let topViewController = TopViewController()
        let navigationController: NavigationController
        
        navigationController = NavigationController(rootViewController: topViewController)
        return navigationController
    }
    
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        //もともとのアニメーションを削除
//        self.view.layer.removeAllAnimations()
//        if(animated){
//            //新しいアニメーションをつける
//            let transition:CATransition = CATransition()
//            transition.duration = 0.25
//            transition.type = CATransitionType.moveIn
//            transition.subtype = CATransitionSubtype.fromTop
//            self.view.layer.add(transition,forKey:kCATransition)
//        }
//        return super.pushViewController(viewController, animated: false)
//    }
}
