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
    let nameBehaviorSubject = BehaviorSubject<Profile>(value: Profile(name: "名無し", imageURL: URL(string: LocalizeString.sampleImageURLString)!))
    
//    private let storageClient: StorageClient = StorageClient()
    
    private let loadUserDefaults = LoadUserDefaults()
    
    
    init() {
        loadUserDefaults.loadUserInfoUserDefaults { (profile) in
            nameBehaviorSubject.subscribe({ (event) in
                print(profile.name)
                
            }).disposed(by: disposeBag)
            nameBehaviorSubject.on(.next(profile))
        }
    }
    

    
}
