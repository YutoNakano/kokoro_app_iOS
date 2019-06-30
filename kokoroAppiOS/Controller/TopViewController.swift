//
//  TopViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import LTMorphingLabel
import FirebaseFirestore
import FirebaseStorage
import TwitterKit

protocol TopViewControllerDelegate: class {
    func resetQuestionCount()
}

final class TopViewController: UIViewController {
    
    lazy var charactorImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "charactor"))
        view.addSubview(v)
        return v
    }()
    
    lazy var startButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("診断を始める", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 28)
        v.titleLabel?.textColor = UIColor.white
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 20
        v.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    lazy var watchHistoryButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("過去の診断結果", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 28)
        v.backgroundColor = UIColor.appColor(.gray)
        v.layer.cornerRadius = 20
        v.addTarget(self, action: #selector(watchHistoryButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    lazy var lineButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("LINE@", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-Bold", size: 14)
        v.backgroundColor = UIColor.appColor(.lineGreen)
        v.layer.cornerRadius = 30
        v.addTarget(self, action: #selector(lineButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    lazy var signOutButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "user"), style: .plain, target: self, action: #selector(signOutButtonTapped))
        return v
    }()
    
    var profileImage: UIImage?
    var name: String?
    var twitterSession: TWTRSession?
    
    
    let questionViewController = QuestionViewController()
    let historyViewController = HistoryViewController()
    let signUpViewController = SignUpViewController()
    
    var watchButtonTapHandler: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charactorAnimation()
        let presenter = QuestionPresenter(view: questionViewController)
        questionViewController.inject(presenter: presenter)
        registerUser()
    }
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.appColor(.background)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
        navigationItem.rightBarButtonItem = signOutButton
    }
    
    func makeConstraints() {
        charactorImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(140)
        }
        startButton.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(80)
        }
        watchHistoryButton.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(startButton.snp.bottom).offset(60)
        }
        lineButton.snp.makeConstraints { make in
            make.size.equalTo(68)
            make.bottom.right.equalToSuperview().offset(-25)
        }
    }
    
}


extension TopViewController {
    func charactorAnimation() {
        UIView.animate(withDuration: 2.0, delay: 0.5, options: [.repeat,.autoreverse], animations: {
            self.charactorImageView.center.y += 30
        }) { _ in
            self.charactorImageView.center.y -= 30
        }
    }
    @objc func signOutButtonTapped() {
        Alert.showWithCancel(
            title: "確認",
            message: "サインアウトしますか?",
            button: ("サインアウト", .destructive, {
                UserManager.shared.signOut()
                self.navigationController?.pushViewController(self.signUpViewController, animated: true)
            }),
            on: self
        )
    }
    @objc func startButtonTapped() {
        questionViewController.resetQuestionNumber()
        navigationController?.pushViewController(questionViewController, animated: true)
    }
    @objc func watchHistoryButtonTapped() {
        self.navigationController?.pushViewController(self.historyViewController, animated: true)
    }
    
    @objc func lineButtonTapped() {
        let urlscheme = "http://nav.cx/dY8Nj4x"
        guard let url = URL(string: urlscheme) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (succes) in
                })
            }else{
                UIApplication.shared.openURL(url)
            }
        }else {
            let alertController = UIAlertController(
                title: "エラー",
                message: "LINEがインストールされていません",
                preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        }
    }
    
    func registerUser() {
        let logInButton = TWTRLogInButton(logInCompletion: { session, err in
            if let err = err { return }
            if let session = session {
                let authToken = session.authToken
                let authTokenSecret = session.authTokenSecret
                self.twitterSession = session
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, err) in
                    if let err = err { return }
                    //Session情報からログインしたユーザー情報を取得で使用
                    self.fetchTwitterUser()
                }
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }
    
    func fetchTwitterUser() {
        
        let user = Auth.auth().currentUser
        if let user = user {
            print("Successfully created a Twitter account in Firebase: \(user.uid)")
        }
        //            guard let url = URL(string: photoUrlString) else { return }
        
        
        guard let twitterSession = twitterSession else { return }
        let client = TWTRAPIClient()
        client.loadUser(withID: twitterSession.userID, completion: { (user, err) in
            if let err = err { print(err)
                return }
            guard let user = user else { return }
            
            self.name = user.name
            let profileImageLargeURL = user.profileImageLargeURL
            
            guard let url = URL(string: profileImageLargeURL) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if err != nil { return }
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
        
        let uploadTask = profileImageRef.putData(profileImageUploadData, metadata: nil) { (metadata, err) in
            guard metadata != nil else { return }
            profileImageRef.downloadURL { (url, err) in
                guard let url = url else { return }
                let db = Firestore.firestore()
                db.collection("users").document(uid).setData([
                    "user_id": uid,
                    "name": name,
                    "profileImageUrl": url.absoluteString])
            }
        }
    }
    
    func displayUserImage() {
        if let user = Auth.auth().currentUser {
            let userRef = Firestore.firestore().collection("users").document(user.uid)
            userRef.getDocument(completion: { (document, error) in
                if let document = document, document.exists {
                    let profileImageUrl = document["profileImageUrl"]
//                    let name = document["name"]
                    let url = URL(string: profileImageUrl as! String)
                    do {
                        let data = try Data(contentsOf: url!)
                        let image = UIImage(data: data)
                        self.signOutButton.image = image
//                        self.label.text = name as! String
                    }catch let err {
                        print(err)
                    }
                }
            })
        }
    }
    
}
