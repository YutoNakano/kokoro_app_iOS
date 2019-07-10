//
//  RootViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/22.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import FirebaseAuth
import UIKit
import KRProgressHUD

final class RootViewController: UIViewController {
    enum ViewType {
        // signUpではなくcase intro を追加する
        case signUp
        case main
    }
    
    private var isTest = true
    
    private var viewType: ViewType? {
        didSet {
            guard let type = viewType, oldValue != type else {
                return
            }
            
            switch type {
            case .signUp: currentViewController =
                SignUpViewController()
                
            case .main: currentViewController =
                NavigationController.build()
            }
        }
    }
    
    private(set) var currentViewController: UIViewController? {
        didSet {
            guard let currentViewController = currentViewController else { return }
            
            addChild(currentViewController)
            view.addSubview(currentViewController.view)
            currentViewController.didMove(toParent: self)
            currentViewController.view.frame = view.bounds
            
            guard let oldViewController = oldValue else { return }
            
            view.sendSubviewToBack(currentViewController.view)
            UIView.transition(from: oldViewController.view, to: currentViewController.view, duration: 0.35, options: .transitionCrossDissolve) { _ in
                oldViewController.willMove(toParent: nil)
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParent()
            }
        }
    }
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.appColor(.white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        UserManager.shared.register { [weak self] state in
            switch state {
            case .initial: break
            case .notAuthenticated: self?.viewType = .signUp
            case .authenticated: self?.viewType = .main
            }
        }
    }
}
