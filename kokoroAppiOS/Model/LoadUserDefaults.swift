//
//  LoadUserDefaults.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/08/28.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import FirebaseAuth

final class LoadUserDefaults {
    var userName: String?
    var userImageUrl: URL?
    func loadUserInfoUserDefaults(completion: (Profile) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }

        completion(Profile(name: currentUser.displayName, imageURL: currentUser.photoURL))
    }
}
