//
//  SignUpViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/22.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseUI
import FirebaseStorage
import LTMorphingLabel
import KRProgressHUD
import TwitterKit


final class SignUpViewController: UIViewController {

    lazy var titleImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "logo"))
        view.addSubview(v)
        return v
    }()
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerUser()
    }
    
    func setupView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
        view.backgroundColor = UIColor.appColor(.background)
    }
    
    func makeConstraints() {
        titleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(100)
        }
    }
    
}

extension SignUpViewController {
    func registerUser() {
        let twitterButton = TWTRLogInButton { (session, error) in
            if let err = error {
                print("Twitter login has failed with error:\(err)")
                return
            }
            guard let token  = session?.authToken else { return }
            guard let secret = session?.authTokenSecret else { return }
            
            let credentials = TwitterAuthProvider.credential(withToken: token, secret: secret)
            
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                if let err = error {
                    print("認証失敗:\(err)")
                    return
                }
                print("Successfully created a Twitter account in Firebase: \(user?.uid ?? "")")
                let db = Firestore.firestore()
                db.collection("users").document(user?.uid ?? "").setData([
                    "user_id": user?.uid ?? "",
                    "name": user?.displayName ?? ""
                    ])
            })
        }
        twitterButton.center = self.view.center
        self.view.addSubview(twitterButton)
    }
    
    func registerUser(user: User?) {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let displayName = user.displayName
            //            let email = user.email
            //            let photoURL = user.photoURL
            
            print("Successfully created a Twitter account in Firebase: \(uid)")
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "user_id": uid,
                "name": displayName!
                ])
        }

    }
}
