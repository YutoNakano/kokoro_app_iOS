//
//  SignUpViewModel.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/08/27.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import TwitterKit

struct SignUpViewModel {
    private let twitterClient: TwitterClient = TwitterClient()
    private let userManager: UserManager = UserManager.shared
    
    var name: String? = nil
    var profileImageURL: URL? = nil
    var authCompletion: (() -> Void)? = nil
    
    func loginTwitter() {
//        userManager.saveUserInfoResult
//            .subscribe(){ event in
//
//        }
        userManager.login { session in
            self.twitterClient.fetchTwitterUser(twitterSession: session, completion: { (name, url) in
                self.userManager.saveUserInfoToUserDefaults(name: name, url: url)
            })
        }
    }
}
