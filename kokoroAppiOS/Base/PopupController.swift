//
//  PopupController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/07/17.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit

final class PopupController: UIViewController {
    
    lazy var overlayView: UIView = {
        let v = UIView()
        v.backgroundColor = overlayColor
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(overlayTapped)))
        view.addSubview(v)
        return v
    }()
    
    lazy var contentView: UIView = {
        let v = UIView()
        view.addSubview(v)
        return v
    }()
    
    let viewController: UIViewController
    let overlayColor: UIColor
    
    init(viewController: UIViewController, overlayColor: UIColor? = nil) {
        self.viewController = viewController
        self.overlayColor = UIColor(white: 0.2, alpha: 0.2)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.clear
        
        // popupControllerの子を追加 なぜ必要なのか?
        addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        makeConstraints()
        
    }
    
    func makeConstraints() {
        overlayView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(viewController.preferredContentSize)
        }
        viewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.sendSubviewToBack(overlayView)
    }
    
}

extension PopupController: UIViewControllerTransitioningDelegate {

}

extension PopupController {
    @objc func overlayTapped() {
        dismiss(animated: true, completion: nil)
    }
}
