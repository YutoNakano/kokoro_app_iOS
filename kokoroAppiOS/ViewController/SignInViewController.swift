//
//  SignInViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/07/10.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import TwitterKit


final class SignInViewController: UIViewController {
    
    lazy var signInView: ThirdIntroView = {
        let v = ThirdIntroView()
        view.addSubview(v)
        return v
    }()
    
    private let screenWidth = UIScreen.main.bounds.width
    private var name: String?
    private var profileImage: UIImage?
    private var twitterSession: TWTRSession?
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
        view.backgroundColor = UIColor.appColor(.background)
    }
    
    func makeConstraints() {
        signInView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SignInViewController {
    func twitterAuth() {
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if let err = error {
                print("Twitter login has failed with error:\(err)")
                return
            }
            guard let token  = session?.authToken else { return }
            guard let secret = session?.authTokenSecret else { return }
            self.twitterSession = session
            
            let credentials = TwitterAuthProvider.credential(withToken: token, secret: secret)
            
            Auth.auth().signInAndRetrieveData(with: credentials, completion: { (authDataResult, error) in
                if let err = error {
                    print("認証失敗:\(err)")
                    return
                }
                self.fetchTwitterUser()
            })
        }
    }
    
    func fetchTwitterUser() {
        guard let twitterSession = twitterSession else { return }
        let client = TWTRAPIClient()
        client.loadUser(withID: twitterSession.userID, completion: { (user, err) in
            if let err = err { return }
            guard let user = user else { return }
            
            self.name = user.name
            let profileImageLargeURL = user.profileImageLargeURL
            
            guard let url = URL(string: profileImageLargeURL) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err { return }
                guard let data = data else { return }
                self.profileImage = UIImage(data: data)
                self.saveUserInfoFirebaseDatabase()
                }.resume()
        })
    }
    
    func saveUserInfoFirebaseDatabase() {
        guard let uid = Auth.auth().currentUser?.uid,
            let name = self.name, let profileImage = profileImage,
            let profileImageUploadData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        let profileImageRef = Storage.storage().reference().child("profileImages").child(uid)
        
        DispatchQueue.main.async {
            let uploadTask = profileImageRef.putData(profileImageUploadData, metadata: nil) { (metadata, err) in
                guard let metadata = metadata else { return }
                profileImageRef.downloadURL { (url, err) in
                    guard let url = url else { return }
                    let dictionaryValues = ["user_id": uid,
                                            "name": name,
                                            "profileImageUrl": url.absoluteString] as [String : Any]
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).setData(dictionaryValues) { err in
                        if let err = err { return }
                    }
                }
            }
        }
    }
}


extension SignInViewController: ThirdIntroViewDelegate {
    func twitterLoginButtonTapped() {
        twitterAuth()
    }
}
