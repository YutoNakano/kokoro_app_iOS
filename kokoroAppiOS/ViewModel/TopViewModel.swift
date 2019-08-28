//
//  TopViewModel.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/08/28.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct TopViewModel {

    let disposeBag = DisposeBag()
    let nameBehaviorSubject = BehaviorSubject<String>(value: "中野")
    
    var name: String? = nil
    var imageURL: URL? = nil
//    private let storageClient: StorageClient = StorageClient()
    
    private let loadUserDefaults = LoadUserDefaults()
    
    
    init() {
//        storageClient.fetchUserData { (profile) in
//            nameBehaviorSubject.subscribe ({ (event) in
//                print("あああああ")
//            }).addDisposableTo(disposeBag)
//            nameBehaviorSubject.on(.next(profile.name))
//            nameBehaviorSubject.on(.completed)
//        }
        loadUserDefaults.loadUserInfoUserDefaults { (profile) in
            nameBehaviorSubject.subscribe({ (event) in
                print("ああああ")
                print(event.element)
            }).disposed(by: disposeBag)
            
            nameBehaviorSubject.on(.next(profile.name))
            nameBehaviorSubject.on(.completed)
        }
    }
    

    
}
