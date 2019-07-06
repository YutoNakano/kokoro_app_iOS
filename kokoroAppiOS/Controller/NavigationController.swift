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
}


//static func build() -> NavigationController{
//    let topViewController = TopViewController()
//    var navigationController = NavigationController()
//    let charactorCompletion = ({ () in
//        navigationController = NavigationController(rootViewController: topViewController)
//    })
//    topViewController.fetchCharactorDescription(completion: charactorCompletion)
//    return navigationController
//}
