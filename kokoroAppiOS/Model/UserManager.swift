//
//  UserManager.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/22.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

final class UserManager {
    
    static let shared = UserManager()
    private var hundle: AuthStateDidChangeListenerHandle?
    
    private init() { }
    
    
    func signUp(withName name: String, completion:@escaping (Result<(), Error>) -> Void) {
        // 認証済み
        if Auth.auth().currentUser != nil {
            return
        }
        //　新規登録の処理
        Auth.auth().signInAnonymously { authDataResult, error in
            switch Result(authDataResult, error) {
            case let .success(authDataResult):
                let db = Firestore.firestore()
                db.collection("Users").document(authDataResult.user.uid).setData([
                    "name": name
                    ])
                print("登録成功")
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
}

public extension Result {
    init(_ success: Success?, _ failure: Failure?) {
        if let success = success {
            self = .success(success)
        } else if let failure = failure {
            self = .failure(failure)
        } else {
            fatalError("Illegal combination found.\n Success: \(success as Any), Failure: \(failure as Any)")
        }
    }
}
