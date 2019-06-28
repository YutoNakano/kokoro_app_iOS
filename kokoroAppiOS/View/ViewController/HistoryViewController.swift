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
    
    let screenWidth = UIScreen.main.bounds.width
    
    lazy var historyCollectionView: HistoryDetailCollectionView = {
        let v = HistoryDetailCollectionView()
        view.addSubview(v)
        return v
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()

    var watchButtonTapHandler: (() -> Void)?
    var histories: [Document<History>] = []
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
        handeler()
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
    
    func handeler() {
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
                .order(by: "diagnosticTime", descending: true)}) { result in
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
        historyCollectionView.histories = histories
    }
}
