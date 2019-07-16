//
//  ResultViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import LTMorphingLabel
import FirebaseFirestore

final class ResultViewController: UIViewController {
    
    lazy var resultContentView: ResultContentView = {
        let v = ResultContentView()
        view.addSubview(v)
        return v
    }()
    
    lazy var goNextButton: MaterialButton = {
        let v = MaterialButton()
        v.setTitle("次へ", for: .normal)
        v.setTitleColor(UIColor.white, for: .normal)
        v.titleLabel?.font = UIFont(name: "GillSans-UltraBold", size: 28)
        v.backgroundColor = UIColor.appColor(.yesPink)
        v.layer.cornerRadius = 20
        v.addTarget(self, action: #selector(goNextButtonTapped), for: .touchUpInside)
        view.addSubview(v)
        return v
    }()
    
    lazy var supportDescriptionView: ScrollTextView = {
        let v = ScrollTextView()
        v.titleLabel.text = ""
        v.memoLabel.text =
        """
        もし、行ってみたが相談した相手にわかってもらえなかった、対応が悪かった、など、せっかく前に一歩踏み出したのに良い結果が出なかった場合、それはあなたのせいでは決してありませんし、そこで絶望する必要は全くありません。人と人の関わりにもなるので、合う合わないの相性もあります｡ﾟ(>_<)ﾟ｡\n同じ「精神科/心療内科/カウンセラー/保健所」というジャンルの人でも、与えてくれる言葉や診断は異なることも充分あり得ます。しかし、今の辛い状況を我慢する、放置することは、あなた自身にとって一番苦しいことです。1人で解決できる問題ではないからです。
        あなたを救うための機関や専門家が沢山います。\n
        このアプリを作った目的は、苦しんでいたり悩んでいる貴方が、なるべく苦労せず自分に合った窓口を選ぶためです。必ず悩みが解決するとは言えませんが、一方踏み出しやすくなって頂けたら幸いです。\n
        
        心の状態は変わります。その時の貴方がどこに行くのがいいのか、それも変わるかもしれません。思いついた時に、診断してみて、気が向いたらでもいいので、足を運んでみてください。
        貴方の心が少しでも、楽になりますように。
        """
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    var questions: [String]
    var selectedAnswers: [SelectedAnswers]
    var topViewController: TopViewController?
    
    let screenWidth = UIScreen.main.bounds.width
    var resultTitle: String = ""
    var resultDescription: String = ""
    let userDefaults = UserDefaults.standard
    
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
        setupView()
        makeConstraints()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupView() {
        view.backgroundColor = UIColor.appColor(.background)
        resultContentView.titleLabel.text = "診断結果: \(resultTitle)"
        resultContentView.descriptionLabel.text = resultDescription
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        
    }
    
    func makeConstraints() {
        resultContentView.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.height.equalTo(300)
            make.width.equalTo(screenWidth - 30)
            make.centerX.equalToSuperview()
        }
        supportDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(resultContentView.snp.bottom).offset(80)
            make.left.right.equalToSuperview()
        }
        goNextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-80)
            make.centerX.equalTo(resultContentView.snp.centerX)
            make.height.equalTo(80)
            make.width.equalTo(220)
        }
    }
}

extension ResultViewController {
    @objc func goNextButtonTapped() {
        guard let topViewController = topViewController else { return }
        let resultDetailViewController = ResultDetailViewController(topVC: topViewController, title: resultTitle, questions: questions, selectedAnswers: selectedAnswers)
        self.navigationController?.pushViewController(resultDetailViewController, animated: true)
    }
    @objc func backButtonTapped() {
        userDefaults.removeObject(forKey: "memoText")
        guard let topViewController = topViewController else { return }
        navigationController?.pushViewController(topViewController, animated: true)
    }
}

extension ResultViewController {
    func fetchResultData(resultIndex: Int, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("Questions")
            .document(resultIndex.description)
            .getDocument { document, error in
                if let err = error {
                    print(err)
                } else {
                    guard let title = document?.data()?["title"] as? String else { return }
                    guard let description = document?.data()?["description"] as? String else { return }
                    print(document?.data()! ?? "結果なし")
                    completion()
                    self.passQuestionResult(title: title, description: description)
                }
        }
    }
    
    func passQuestionResult(title: String, description: String) {
        resultTitle = title
        resultDescription = description
    }
}

