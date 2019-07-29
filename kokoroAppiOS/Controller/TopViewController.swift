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
import LTMorphingLabel
import FirebaseFirestore

protocol TopViewControllerDelegate: class {
    func resetQuestionCount()
}

final class TopViewController: UIViewController {
    
    lazy var charactorDescriptionLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 4
        v.adjustsFontSizeToFitWidth = true
        v.textAlignment = .center
        v.font = UIFont(name: "RoundedMplus1c-Medium", size: 22)
        v.textColor = UIColor.appColor(.character)
        view.addSubview(v)
        return v
    }()
    
    lazy var charactorImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: CharactorImageState.normal.rawValue))
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = .zero
        v.layer.shadowOpacity = 0.3
        v.layer.shadowRadius = 4
        view.addSubview(v)
        return v
    }()
    
    lazy var backgroundImage: UIImageView = {
        let v = UIImageView(image: UIImage(named: "background"))
        view.addSubview(v)
        return v
    }()
    
    lazy var startButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("診断する", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 24)
        v.titleLabel?.textColor = UIColor.white
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 20
        v.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    lazy var watchHistoryButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("過去の\n診断結果", for: .normal)
        v.titleLabel?.textAlignment = .center
        v.titleLabel?.numberOfLines = 2
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 24)
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
        v.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 16)
        v.backgroundColor = UIColor.appColor(.lineGreen)
        v.layer.cornerRadius = 30
        v.addTarget(self, action: #selector(lineButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    lazy var signOutButton: UIButton = {
        let v = UIButton(target: self, action: #selector(signOutButtonTapped))
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 20
        return v
    }()
    
    let historyViewController = HistoryViewController()
    let screenWidth = UIScreen.main.bounds.width
    var charactorDescriptionArray: [String] = []
    var nomalToCloseEyeImageTimer: Timer?
    var closeEyeToNormalImageTimer: Timer?
    var timerCount = 0
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
        setUpTimer()
        charactorAnimation()
        loadUserInfoFromUserDefaults()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let toColseEyeTimer = nomalToCloseEyeImageTimer, let toNomalTimer = closeEyeToNormalImageTimer {
            toColseEyeTimer.invalidate()
            toNomalTimer.invalidate()
        }
    }
    
    func setupView() {
        view.backgroundColor = UIColor.appColor(.background)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOutButton)
        navigationController?.navigationBar.isTranslucent = false
        edgesForExtendedLayout = []
        navigationItem.hidesBackButton = true
    }
    
    func makeConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        signOutButton.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        charactorDescriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(screenWidth - 80)
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        charactorImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).offset(-80)
        }
        startButton.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(80)
            make.bottom.equalToSuperview().offset(-160)
            make.right.equalToSuperview().offset(-40)
        }
        watchHistoryButton.snp.makeConstraints { make in
            make.size.equalTo(startButton.snp.size)
            make.centerY.equalTo(startButton.snp.centerY)
            make.left.equalToSuperview().offset(40)
        }
        lineButton.snp.makeConstraints { make in
            make.size.equalTo(68)
            make.bottom.right.equalToSuperview().offset(-25)
        }
    }
}

enum CharactorImageState: String {
    case normal = "charactor"
    case closeEye = "charactor_eye_close"
}


extension TopViewController {
    func charactorAnimation() {
        UIView.animate(withDuration: 2.0, delay: 0.3, options: [.repeat,.autoreverse], animations: {
            self.charactorImageView.center.y += 25
        }) { _ in
            self.charactorImageView.center.y -= 25
        }
    }
    
    func setUpTimer() {
        nomalToCloseEyeImageTimer = Timer.scheduledTimer(timeInterval: setTimeInterval(), target: self, selector: #selector(normalToCloseEyeTimerAction), userInfo: nil, repeats: true)
    }
    
    func setTimeInterval() -> TimeInterval {
        return TimeInterval(Float.random(in: 4...6))
    }
    
    @objc func normalToCloseEyeTimerAction() {
        charactorImageView.image = UIImage(named: CharactorImageState.closeEye.rawValue)
        // 画像をnomalに戻すTimer
        closeEyeToNormalImageTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(closeEyeToNormalTimerAction), userInfo: nil, repeats: true)
    }
    
    @objc func closeEyeToNormalTimerAction() {
        charactorImageView.image = UIImage(named: CharactorImageState.normal.rawValue)
        if let toNomalTimer = closeEyeToNormalImageTimer {
            toNomalTimer.invalidate()
        }
    }
    
    @objc func startButtonTapped() {
        let questionViewController = QuestionViewController(topVC: self)
        questionViewController.resetQuestionNumber()
        navigationController?.pushViewController(questionViewController, animated: true)
    }
    @objc func watchHistoryButtonTapped() {
        self.navigationController?.pushViewController(historyViewController, animated: true)
    }
    
    @objc func signOutButtonTapped() {
        Alert.showWithCancel(
            title: "確認",
            message: "サインアウトしますか?",
            button: ("サインアウト", .destructive, {
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                UserManager.shared.signOut()
            }),
            on: self
        )
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

                        self.charactorDescriptionLabel.text = "\(name ?? "名無し")さんお帰りなさい!"
                    }catch let err {
                        print(err)
                    }
                }
                }
            })
        }
    }
    
    func setModel() {
        charactorDescriptionLabel.text = charactorDescriptionArray[generateRandomNumber()]
    }
    func generateRandomNumber() -> Int {
        return Int.random(in: 0 ... charactorDescriptionArray.count - 1)
    }
    
    func loadUserInfoFromUserDefaults() {
        let userDefaults = UserDefaults.standard
    
        if userDefaults.object(forKey: "userName") != nil {
            let userName: String? = userDefaults.object(forKey: "userName") as? String
            let profileImageURL: URL? = userDefaults.url(forKey: "profileImageData")
        
            self.charactorDescriptionLabel.text = "\(userName ?? "名無し")さんお帰りなさい!"
            signOutButton.kf.setImage(with: profileImageURL, for: .normal)
        }
    }
}
