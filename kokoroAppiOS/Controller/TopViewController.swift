//
//  TopViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import FirebaseAuth
import FirebaseFirestore

protocol TopViewControllerDelegate: class {
    func resetQuestionCount()
}

final class TopViewController: UIViewController {
    
    lazy var topCharactorView: TopCharactorView = {
        let v = TopCharactorView()
        view.addSubview(v)
        return v
    }()
    
    lazy var topMenuButtonView: TopMenuButtonView = {
        let v = TopMenuButtonView()
        v.delegate = self
        view.addSubview(v)
        return v
    }()
    
    lazy var signOutButton: UIButton = {
        let v = UIButton(target: self, action: #selector(signOutButtonTapped))
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 20
        return v
    }()
    
    lazy var backgroundImage: UIImageView = {
        let v = UIImageView(image: UIImage(named: "background"))
        view.addSubview(v)
        return v
    }()
    
    let historyViewController = HistoryViewController()
    let screenHeight = UIScreen.main.bounds.height
    var charactorDescriptionArray: [String] = []
    var charactorState = true
    var profileImage: UIImage?
    
    var watchButtonTapHandler: (() -> Void)?
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
        fetchUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCharactorDescription()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadUserInfoFromUserDefaults()
        topCharactorView.charactorAnimation()
        topCharactorView.setUpTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        topCharactorView.invalidateTimer()
        view.layer.removeAllAnimations()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.appColor(.background)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOutButton)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.hidesBackButton = true
    }
    
    func makeConstraints() {
        topCharactorView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(screenHeight / 1.8)
        }
        topMenuButtonView.snp.makeConstraints { make in
            make.top.equalTo(topCharactorView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        signOutButton.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        view.bringSubviewToFront(topCharactorView)
        view.bringSubviewToFront(topMenuButtonView)
    }
}

extension TopViewController {
    @objc func signOutButtonTapped() {
        Alert.showWithCancel(
            title: "確認",
            message: "サインアウトしますか?",
            button: ("サインアウト", .destructive, {
                guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return }
                let domain = bundleIdentifier
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                UserManager.shared.signOut()
            }),
            on: self        )
    }
    
    func fetchCharactorDescription() {
        let db = Firestore.firestore()
        db.collection("charactor_description")
        .document(1.description)
            .getDocument { document, error in
                if let err = error {
                    print(err)
                } else {
                    guard let descriptionArray = document?.data()?["text"] as? [String] else { return }
                    self.charactorDescriptionArray = descriptionArray
                }
        }
    }
    
    func fetchUserData() {
        if let user = Auth.auth().currentUser {
            let userRef = Firestore.firestore().collection("users").document(user.uid)
            userRef.getDocument(completion: { (document, error) in
                if let document = document, document.exists {
                    let profileImageUrl = document["profileImageUrl"]
                    let name = document["name"]
                    guard let urlString = profileImageUrl as? String else { return }
                    if let url = URL(string: urlString) {
                    do {
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)
                        self.signOutButton.setImage(image, for: .normal)

                        self.topCharactorView.charactorDescriptionLabel.text = "\(name ?? "名無し")さんお帰りなさい!"
                    }catch let err {
                        print(err)
                    }
                }
                }
            })
        }
    }
    // キャラクターの文言をランダムに表示
    func setCharactorDescription() {
        topCharactorView.charactorDescriptionLabel.text = charactorDescriptionArray[generateRandomNumber()]
    }
    func generateRandomNumber() -> Int {
        return Int.random(in: 0 ... charactorDescriptionArray.count - 1)
    }
    
    func loadUserInfoFromUserDefaults() {
        let userDefaults = UserDefaults.standard
    
        if userDefaults.object(forKey: "userName") != nil {
            let userName: String? = userDefaults.object(forKey: "userName") as? String
            let profileImageURL: URL? = userDefaults.url(forKey: "profileImageData")
        
            self.topCharactorView.charactorDescriptionLabel.text = "\(userName ?? "名無し")さんお帰りなさい!"
            signOutButton.kf.setImage(with: profileImageURL, for: .normal)
        }
    }
}

extension TopViewController: TopMenuButtonViewDelegate{
    func didTapLineButton() {
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
    
    func didTapStartButton() {
        let questionViewController = QuestionViewController(topVC: self)
        questionViewController.resetQuestionNumber()
        navigationController?.pushViewController(questionViewController, animated: true)
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return }
        let domain = bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    func didTapWatchHistoryButton() {
        self.navigationController?.pushViewController(historyViewController, animated: true)
    }
}
