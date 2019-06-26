//
//  PresenterInterface.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/26.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation

public protocol PresenterInterface: class {
    
    // Lifecycle
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    
}

extension PresenterInterface {
    
    public func viewDidLoad() { }
    
    public func viewWillAppear() { }
    
    public func viewDidAppear() { }
    
}
