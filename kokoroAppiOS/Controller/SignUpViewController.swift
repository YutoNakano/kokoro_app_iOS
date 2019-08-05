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
import TwitterKit
import Kingfisher


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
    var profileImageURL: URL?
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.layer.removeAllAnimations()
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
        TWTRTwitter.sharedInstance().logIn { [weak self] (session, error) in
            if let err = error {
                print("Twitter login has failed with error:\(err)")
                return
            }
            guard let token  = session?.authToken else { return }
            guard let secret = session?.authTokenSecret else { return }
            self?.twitterSession = session
            
            let credentials = TwitterAuthProvider.credential(withToken: token, secret: secret)
            Auth.auth().signInAndRetrieveData(with: credentials, completion: { [weak self] (authDataResult, error) in
                if let err = error {
                    print("認証失敗:\(err)")
                    return
                }
                self?.registerUser()
            })
            self?.fetchTwitterUser()
        }
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
        self.saveUserInfoToUserDefaults()
    }
    
    func fetchTwitterUser() {
        guard let twitterSession = twitterSession else { return }
        let client = TWTRAPIClient()
        client.loadUser(withID: twitterSession.userID, completion: { [weak self](user, err) in
            if let _ = err { return }
            guard let user = user else { return }

            self?.name = user.name
            let profileImageURLString = user.profileImageLargeURL
            
            guard let url = URL(string: profileImageURLString) else { return }
            self?.profileImageURL = url
        })
    }
    
    func saveUserInfoToUserDefaults() {
        let userDefalts = UserDefaults.standard
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userDefalts.set(uid, forKey: "userID")
        userDefalts.set(name, forKey: "userName")
        userDefalts.set(profileImageURL, forKey: "profileImageData")
        userDefalts.synchronize()
        guard let url = profileImageURL else { return }
        do {
            let data = try Data(contentsOf: url)
            saveUserInfoToFirebaseDatabase(imageData: data)
        }catch let err {
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
