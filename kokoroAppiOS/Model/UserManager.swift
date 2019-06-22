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
    
    enum State {
        case initial
        case notAuthenticated
        case authenticated
    }
    // テスト
    private let isTest = true
    
    static let shared = UserManager()
    private var hundle: AuthStateDidChangeListenerHandle?
    private var listeners: [(State) -> Void] = []
    private(set) var currentState: State = .initial {
        didSet {
            listeners.forEach{ $0(currentState)}
        }
    }
    
    private init() { }
    
    func register(listener: @escaping (State) -> Void) {
        listeners.append(listener)
        listener(currentState)
    }
    
    func signUp(withName name: String, completion:@escaping (Result<String, Error>) -> Void) {
        // 認証済み
        if Auth.auth().currentUser != nil {
            if isTest == true {
                Auth.auth().currentUser?.delete { error in
                    if let error = error {
                        print(error)
                    } else {
                     print("テストのためカレントユーザーデータ削除")
                    }
                }
            }
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
                completion(.success("渡された!!!--"))
                completion(.success(self.practice(name: "Trailing Closure内で実行")))
            case let .failure(error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func practice(name: String) -> String {
        return name
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
