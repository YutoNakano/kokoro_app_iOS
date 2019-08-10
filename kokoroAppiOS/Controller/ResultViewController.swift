//
//  ResultViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseFirestore
import SafariServices

enum ResultViewType: Int {
    // 施設が提案された場合
    case psychosomatic = 100
    case psychiatry = 101
    case counseling = 102
    case healthCenter = 103
    // 現在は提案する施設がない場合
    case rest = 7
}

final class ResultViewController: UIViewController {
    
    lazy var resultContentView: ResultContentView = {
        let v = ResultContentView()
        v.delegate = self
//        view.addSubview(v)
        return v
    }()
    
    lazy var goNextButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("次へ", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "RoundedMplus1c-Medium", size: 28)
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 20
        v.addTarget(self, action: #selector(goNextButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    lazy var shareButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareButtonTapped))
        return v
    }()
    
    var topViewController: TopViewController?
    
    let screenWidth = UIScreen.main.bounds.width
    var resultTitle: String = ""
    var resultDescription: String = ""
    let userDefaults = UserDefaults.standard
    
    // モデルからのデータを格納する
    var questions: [String]
    var selectedAnswers: [SelectedAnswers]
    var webString: String?
    var descriptionArray: [String]?
    var urlDict: [String: String]?
    
    init(topVC: TopViewController, questions: [String], selectedAnswers: [SelectedAnswers]) {
        topViewController = topVC
        self.questions = questions
        self.selectedAnswers = selectedAnswers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(resultContentView)
        setupView()
        makeConstraints()
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = shareButton
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.appColor(.noBlue)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.appColor(.noBlue)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultContentView.charactorAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.layer.removeAllAnimations()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.appColor(.background)
        resultContentView.titleLabel.text = "診断結果: \(resultTitle)"
        resultContentView.descriptionLabel.text = resultDescription
        navigationController?.navigationBar.isTranslucent = false

    }
    
    func makeConstraints() {
        resultContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(550)
            make.width.equalTo(screenWidth - 32)
            make.centerX.equalToSuperview()
        }
        goNextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-65)
            make.centerX.equalTo(resultContentView.snp.centerX)
            make.height.equalTo(80)
            make.width.equalTo(220)
        }
    }
}

extension ResultViewController {
    @objc func goNextButtonTapped() {
        let popupHundler = { [weak self] () in
            guard let self = self else { return }
            guard let topViewController = self.topViewController else { return }
            let resultDetailViewController = ResultDetailViewController(topVC: topViewController, title: self.resultTitle, questions: self.questions, selectedAnswers: self.selectedAnswers)
            self.navigationController?.pushViewController(resultDetailViewController, animated: true)
        }
        let vc = SupportDescriptionPopupViewController()
        let popup = PopupController(viewController: vc, hundler: popupHundler)
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true)
    }
    
    @objc func backButtonTapped() {
        userDefaults.removeObject(forKey: "memoText")
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func shareButtonTapped() {
        let shareText = "私は\(resultTitle)に行ってみた方が良いみたい.."
        
        let activityItems = [shareText]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
}

extension ResultViewController {
    func fetchResultData(resultIndex: Int, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("Questions")
            .document(resultIndex.description)
            .getDocument { [weak self] document, error in
                if let err = error {
                    print(err)
                } else {
                    guard let title = document?.data()?["title"] as? String else { return }
                    guard let description = document?.data()?["description"] as? String else { return }
                    guard let urlString = document?.data()?["url"] as? String? else { return }
                    guard let descriptionArray = document?.data()?["descriptionArray"] as? [String]? else { return }
                    guard let urlDict = document?.data()?["urlDict"] as? [String: String]? else { return }
                    completion()
                    self?.passQuestionResult(title: title, description: description, urlString: urlString, urlDict: urlDict, descriptionArray: descriptionArray)
                }
        }
    }
    
    func passQuestionResult(title: String, description: String, urlString: String?, urlDict: [String: String]?,descriptionArray: [String]?) {
        self.resultTitle = title
        self.resultDescription = description
        self.urlDict = urlDict
        self.webString = urlString
        guard let array = descriptionArray else { return }
        self.resultContentView.descriptionStrings = array
    }
    
    func turnDescriptionStateView(resultState: ResultViewType) {
        switch resultState {
        case .psychiatry:
            resultContentView.tableView.isHidden = true
        case .psychosomatic:
            resultContentView.tableView.isHidden = true
        case .counseling:
            resultContentView.tableView.isHidden = true
        case .healthCenter:
            resultContentView.tableView.isHidden = true
        case .rest:
            resultContentView.descriptionLabel.textColor = UIColor.clear
            resultContentView.linkButton.isHidden = true
        }
    }
}

extension ResultViewController: ResultContentViewDelegate {
    enum URLState: Int {
        case normal = 0
        case medical = 1
        case healthCenter = 2
        case counseling = 3
    }
    func linkButtonTapped(buttonTag: Int) {
        guard let urlState = URLState(rawValue: buttonTag) else { return }
        var resultUrlString = ""
        switch urlState {
        case .normal:
            guard let urlString = webString else { return }
            resultUrlString = urlString
        case .medical:
            guard let urlString = urlDict?["medical"] else { return }
            resultUrlString = urlString
        case .healthCenter:
            guard let urlString = urlDict?["helthCenter"] else { return }
            resultUrlString = urlString
        case .counseling:
            guard let urlString = urlDict?["counseling"] else { return }
            resultUrlString = urlString
        }
        goSafariVC(urlString: resultUrlString)
    }
    func goSafariVC(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}
