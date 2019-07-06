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

protocol TopViewControllerDelegate: class {
    func resetQuestionCount()
}

final class TopViewController: UIViewController {
    
    
    lazy var charactorDescriptionLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 4
        v.adjustsFontSizeToFitWidth = true
        v.font = UIFont(name: "GillSans-UltraBold", size: 20)
        v.textColor = UIColor.appColor(.character)
        view.addSubview(v)
        return v
    }()
    
    lazy var charactorImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "charactor"))
        view.addSubview(v)
        return v
    }()
    
    lazy var startButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("診断する", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-Bold", size: 24)
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
        v.titleLabel?.font = UIFont(name: "GillSans-Bold", size: 24)
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
    
    let questionViewController = QuestionViewController()
    let historyViewController = HistoryViewController()
    let signUpViewController = SignUpViewController()
    let screenWidth = UIScreen.main.bounds.width
    var charactorDescriptionArray: [String] = [] {
        didSet {
            setModel()
        }
    }
    
    var watchButtonTapHandler: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        charactorAnimation()
    }
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
        fetchCharactorDescription()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.appColor(.background)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
        navigationItem.rightBarButtonItem = signOutButton
    }
    
    func makeConstraints() {
        charactorDescriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(screenWidth - 80)
            make.top.equalToSuperview().offset(60)
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


extension TopViewController {
    func charactorAnimation() {
        UIView.animate(withDuration: 2.0, delay: 0.5, options: [.repeat,.autoreverse], animations: {
            self.charactorImageView.center.y += 30
        }) { _ in
            self.charactorImageView.center.y -= 30
        }
    }
    
    @objc func startButtonTapped() {
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
                UserManager.shared.signOut()
                self.navigationController?.pushViewController(self.signUpViewController, animated: true)
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
    func setModel() {
        charactorDescriptionLabel.text = charactorDescriptionArray[generateRandomNumber()]
    }
    func generateRandomNumber() -> Int {
        return Int.random(in: 0 ... charactorDescriptionArray.count - 1)
    }
}
