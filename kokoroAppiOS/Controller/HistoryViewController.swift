//
//  HistoryViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/21.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit

final class HistoryViewController: UIViewController {
    
    lazy var historyCollectionView: HistoryCollectionView = {
        let v = HistoryCollectionView()
        v.delegate = self
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    var watchButtonTapHandler: (() -> Void)?
    var didSelectCellTapHandler: (() -> Void)?
    var histories: [Document<History>] = []
    
    let screenWidth = UIScreen.main.bounds.width
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
        fetch()
        self.navigationItem.leftBarButtonItem = backButton
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
    }
    
}

extension HistoryViewController {
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func fetchResultData(completion: @escaping () -> Void) {
        guard let user = UserManager.shared.currentUser else { return }
        let user_id = user.data.user_id
        Document<History>.get(queryBuilder: { q in
            q.whereField("user_id", isEqualTo: user_id)
                .order(by: "timeStamp", descending: true)}) { result in
                    switch result {
                    case let .success(histories):
                        print(histories)
                        self.passResultData(histories: histories)
                        completion()
                    case let .failure(error):
                        print(error)
                    }
        }
    }
    
    func passResultData(histories: [Document<History>]) {
        self.histories = histories
        let array = histories.map { $0.data.timeStamp.dateValue() }
        let format = DateFormatter()
        format.dateFormat = "MM/dd HH:mm"
//        print(format.string(from: array[0]))
//        print(format.string(from: array[1]))
//        print(format.string(from: array[2]))
//        print(format.string(from: array[3]))
//        print(format.string(from: array[4]))
        historyCollectionView.histories = histories
    }
}

extension HistoryViewController: HistoryCollectionViewDelegate {
    func didSelectRow(indexPath: IndexPath) {
        let questions = histories[indexPath.row].data.questions
       let selectedAnswersString = histories[indexPath.row].data.selectedAnswers
        let memoText = histories[indexPath.row].data.memo
        let historyDetailViewController = HistoryDetailViewController(questions: questions, selectedAnswersString: selectedAnswersString, memoText: memoText)
        navigationController?.pushViewController(historyDetailViewController, animated: true)
    }
}
