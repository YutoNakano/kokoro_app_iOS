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
import FirebaseStorage
import LTMorphingLabel
import TwitterKit


final class SignUpViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.isPagingEnabled = true
        v.showsHorizontalScrollIndicator = false
        v.delegate = self
        v.contentSize = CGSize(width: self.view.frame.size.width * 3, height: 200)
        view.addSubview(v)
        return v
    }()
    
    lazy var firstIntroView: FirstIntroView = {
        let v = FirstIntroView(frame: CGRect(x: 0, y: 0, width:
            view.frame.size.width, height: view.frame.size.height))
        return v
    }()
    
    lazy var secondIntroView: SecondIntroView = {
        let v = SecondIntroView(frame: CGRect(x: view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        return v
    }()
    
    lazy var thirdIntroView: ThirdIntroView = {
        let v = ThirdIntroView(frame: CGRect(x: view.frame.size.width * 2, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        v.delegate = self
        return v
    }()
    
    func addIntroviews() {
        let introViews = [firstIntroView, secondIntroView, thirdIntroView]
        introViews.forEach { scrollView.addSubview($0) }
    }
    
    lazy var pageControll: UIPageControl = {
        let v = UIPageControl()
        v.numberOfPages = 3
        v.pageIndicatorTintColor = UIColor.white
        v.currentPageIndicatorTintColor = UIColor.appColor(.yesPink)
        view.addSubview(v)
        return v
    }()
    
    let screenWidth = UIScreen.main.bounds.width
    
    var name: String?
    var profileImage: UIImage?
    var twitterSession: TWTRSession?
    var authCompletion: (() -> Void)?
    
    
    override func loadView() {
        super.loadView()
        setupView()
        addIntroviews()
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
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pageControll.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
}


extension SignUpViewController {
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
                self.registerUser()
            })
        }
    }
    
    func registerUser() {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let displayName = user.displayName
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "user_id": uid,
                "name": displayName!
                ])
            print("認証成功: \(displayName)")
            fetchTwitterUser()
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
                self.saveUserInfoToFirebaseDatabase()
                }.resume()
        })
    }
    
    func saveUserInfoToFirebaseDatabase() {
        guard let uid = Auth.auth().currentUser?.uid,
            let name = self.name, let profileImage = profileImage,
            let profileImageUploadData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        
        let profileImageRef = Storage.storage().reference().child("profileImages").child(uid)
        saveUserInfoToUserDefaults(id: uid, name: name, profileImageData: profileImage.pngData())
        DispatchQueue.main.async {
            let uploadTask = profileImageRef.putData(profileImageUploadData, metadata: nil) { (metadata, err) in
                guard let metadata = metadata else { return }
                profileImageRef.downloadURL { (url, err) in
                    guard let url = url else { return }
                    let dictionaryValues = ["profileImageUrl": url.absoluteString] as [String : Any]
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).updateData(dictionaryValues) { err in
                        if let err = err { return }
                    }
                }
            }
        }
    }
    // ユーザーのid・name・profileImageを保存
    func saveUserInfoToUserDefaults(id: String, name: String, profileImageData: Data?) {
        let userDefalts = UserDefaults.standard
        userDefalts.set(id, forKey: "userID")
        userDefalts.set(name, forKey: "userName")
        userDefalts.set(profileImageData, forKey: "profileImageData")
        userDefalts.synchronize()
    }
    
}

extension SignUpViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControll.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}

extension SignUpViewController: ThirdIntroViewDelegate {
    func twitterLoginButtonTapped() {
        twitterAuth()
    }
}
