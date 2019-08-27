//
//  UserManager.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/22.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import TwitterKit


final class UserManager {
    enum State {
        case initial
        case notAuthenticated
        case authenticated(Document<User>)
    }
    
    static let shared = UserManager()
    private var hundle: AuthStateDidChangeListenerHandle?
    private var listeners: [(State) -> Void] = []
    private(set) var currentState: State = .initial {
        didSet {
            listeners.forEach{ $0(currentState) }
        }
    }
    
    private var session: TWTRSession?
    
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
            print(authUser.uid)
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
        listeners.append(listener)
        listener(currentState)
    }
    
    func practice(name: String) -> String {
        return name
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    func registerUser() {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            guard let displayName = user.displayName else { return }
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "user_id": uid,
                "name": displayName
                ])
        }
    }
    
    func saveUserInfoToUserDefaults(name: String, url: URL) {
        let userDefalts = UserDefaults.standard
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userDefalts.set(uid, forKey: "userID")
        userDefalts.set(name, forKey: "userName")
        userDefalts.set(url, forKey: "profileImageData")
        userDefalts.synchronize()
        do {
            let data = try Data(contentsOf: url)
            saveUserInfoToFirebaseDatabase(imageData: data)
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
    }
    
    func saveUserInfoToFirebaseDatabase(imageData: Data) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let profileImageRef = Storage.storage().reference().child("profileImages").child(uid)
        guard let jpegData = UIImage(data: imageData)?.jpegData(compressionQuality: 0.3) else { return }
        DispatchQueue.main.async {
            let _ = profileImageRef.putData(jpegData, metadata: nil) { (metadata, err) in
                guard let _ = metadata else { return }
                profileImageRef.downloadURL { (url, err) in
                    guard let url = url else { return }
                    let dictionaryValues = ["profileImageUrl": url.absoluteString] as [String : Any]
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).updateData(dictionaryValues) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Successfully update")
                         }
                    }
                }
            }
        }
    }
    
    func login(completion: @escaping ((TWTRSession) -> Void)) {
        twitterAuth { (result) in
            switch result {
            case let .success(credentials):
                self.signin(with: credentials, completion: { (result) in
                    guard let session = self.session else { return }
                    completion(session)
                })
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func twitterAuth(completion: @escaping (Result<AuthCredential, Error>) -> Void) {
        TWTRTwitter.sharedInstance().logIn { [weak self] (session, error) in
            if let err = error {
                print("Twitter login has failed with error:\(err)")
                return
            }
            guard let token  = session?.authToken else { return }
            guard let secret = session?.authTokenSecret else { return }
            self?.session = session
            let credentials = TwitterAuthProvider.credential(withToken: token, secret: secret)
            completion(.success(credentials))
        }
    }
    
    private func signin(with credentials: AuthCredential, completion: @escaping (Result<(), Error>) -> Void) {
        Auth.auth().signInAndRetrieveData(with: credentials) { [weak self] (authDataResult, error) in
            if let err = error {
                print("認証失敗:\(err)")
                completion(.failure(err))
                return
            }
            completion(.success(()))
            self?.registerUser()
        }
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
