//
//  SignUpViewModel.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/08/27.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import FirebaseAuth
import Swifter

struct SignUpViewModel {
    private let twitterClient: TwitterClient = TwitterClient()
    private let userManager: UserManager = UserManager.shared
    
    var name: String? = nil
    var profileImageURL: URL? = nil
    var authCompletion: (() -> Void)? = nil
    
    let swifter = Swifter(consumerKey: Config.consumerKey, consumerSecret: Config.secretKey)
    
    func loginTwitter() {
        
        //        swifter.authorize(
        //            withCallback: URL(string: "swifter-vYMAjoO5ulHsRph24zbuEtAwY://")!,
        //            presentingFrom: self,
        //            success: { accessToken, response in
        //                // このあとaccessToken使うよ
        //        }, failure: { error in
        //            print(error)
        //        })
        
        
        //        userManager.login { session in
        //            self.twitterClient.fetchTwitterUser(twitterSession: session, completion: { (name, url) in
        //                self.userManager.saveUserInfoToUserDefaults(name: name, url: url)
        //            })
    }
    //    }
}

