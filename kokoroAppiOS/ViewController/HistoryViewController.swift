//
//  HistoryViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/21.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseFirestore

final class HistoryViewController: UIViewController {
    
    lazy var historyCollectionView: HistoryCollectionView = {
        let v = HistoryCollectionView()
        v.delegate = self
        let refleshControl = UIRefreshControl()
        refleshControl.addTarget(self, action: #selector(refleshScrolled(sender:)), for: .valueChanged)
        v.collectionView.refreshControl = refleshControl
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    private var watchButtonTapHandler: (() -> Void)?
    private var didSelectCellTapHandler: (() -> Void)?
    
    private var questions: [[String]] = []
    private var selectedAnswers: [[String]] = []
    private var memos: [String] = []
    
    private let screenWidth = UIScreen.main.bounds.width
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
        fetch()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func makeConstraints() {
        historyCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func setupView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
    }
    
    func fetch() {
        watchButtonTapHandler = ({ () in
            self.historyCollectionView.collectionView.reloadData()
        })
        guard let completion = watchButtonTapHandler else { return }
        fetchResultData(completion: completion)
        historyCollectionView.collectionView.refreshControl?.endRefreshing()
    }
    
}

extension HistoryViewController {
    @objc func refleshScrolled(sender: UIRefreshControl) {
        fetch()
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func fetchResultData(completion: @escaping () -> Void) {
        guard let user = UserManager.shared.currentUser else { return }
        let user_id = user.data.user_id
        let db = Firestore.firestore()
        let query = db.collection("histories").whereField("user_id", isEqualTo: user_id)
            .order(by: "timeStamp", descending: true)
        
        query.getDocuments { [weak self] document, error in
            if let err = error {
                print(err)
            } else {
                guard let questions: [[String]] = (document?.documents.map { $0.data()["questions"] } as? [[String]]),
                    let selectAnswers: [[String]] = (document?.documents.map { $0.data()["selectedAnswers"] } as? [[String]]),
                    let resultTitle: [String] = (document?.documents.map { $0.data()["title"] }) as? [String],
                    let memo: [String] = (document?.documents.map { $0.data()["memo"] }) as? [String],
                    let timeStamp: [Timestamp] = (document?.documents.map { $0.data()["timeStamp"] }) as? [Timestamp] else { return }
                self?.passResultData(questions: questions, selectedAnswers: selectAnswers, memos: memo, titles: resultTitle, timeStamps: timeStamp)
                completion()
            }
        }
    }
    
    func passResultData(questions:[[String]], selectedAnswers: [[String]], memos: [String], titles: [String], timeStamps: [Timestamp]) {
        historyCollectionView.resultTitles = titles
        let dates = timeStamps.map { $0.dateValue() }
        historyCollectionView.timeStamps = dateFormat(timeStamps: dates)
        self.questions = questions
        self.selectedAnswers = selectedAnswers
        self.memos = memos
    }
    
    func dateFormat(timeStamps: [Date]) -> [String] {
        let format = DateFormatter()
        format.dateFormat = "MM/dd HH:mm"
        let dates = timeStamps.map { format.string(from: $0) }
        return dates
    }
}

extension HistoryViewController: HistoryCollectionViewDelegate {
    func didSelectRow(indexPath: IndexPath) {
        let questionsArray = questions[indexPath.row]
        let selectedAnswersString = selectedAnswers[indexPath.row]
        let memoText = memos[indexPath.row]
        let historyDetailViewController = HistoryDetailViewController(questions: questionsArray, selectedAnswersString: selectedAnswersString, memoText: memoText)
        navigationController?.pushViewController(historyDetailViewController, animated: true)
    }
}
