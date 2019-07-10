//
//  UserManager.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/22.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import Firebase

final class UserManager {
    
    enum State {
        case initial
        case notAuthenticated
        case authenticated(Document<User>)
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
    
    var currentUser: Document<User>? {
        switch currentState {
        case .initial: return nil
        case .notAuthenticated: return nil
        case let .authenticated(user): return user
        }
    }
    
    private init() {
        // ユーザーの登録状態が変化したら呼ばれる
        hundle = Auth.auth().addStateDidChangeListener { [unowned self] _, user in
            self.fetch(authUser: user)
        }
    }
    
    func fetch(authUser: Firebase.User? = Auth.auth().currentUser) {
        guard let authUser =  authUser else {
            currentState = .notAuthenticated
            return
        }
        
        Document<User>.get(documentID: authUser.uid) { result in
            switch result {
            case let .success(user):
                if let user = user {
                    self.currentState = .authenticated(user)
                } else {
                    self.currentState = .notAuthenticated
                }
            case let .failure(error):
                print(error)
                self.currentState = .notAuthenticated
            }
        }
    }
    
    func register(listener: @escaping (State) -> Void) {
        // listenersにSwitch文クロージャが入ってる
        listeners.append(listener)
        listener(currentState)
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
