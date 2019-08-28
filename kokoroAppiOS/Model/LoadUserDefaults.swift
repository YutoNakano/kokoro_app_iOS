//
//  LoadUserDefaults.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/08/28.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation

final class LoadUserDefaults {
    var userName: String?
    var userImageUrl: URL?
    func loadUserInfoUserDefaults(completion: (Profile) -> Void) {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.object(forKey: "userName") != nil {
            let userName: String? = userDefaults.object(forKey: "userName") as? String
            let profileImageURL: URL? = userDefaults.url(forKey: "profileImageData")
            
            self.userName = userName
            self.userImageUrl = profileImageURL
        }
        print(userName)
        print(userImageUrl)
        guard let name = userName, let url = userImageUrl else { return }
        completion(Profile(name: name, imageURL: url))
    }
}
