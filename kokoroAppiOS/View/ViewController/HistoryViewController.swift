//
//  HistoryViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/21.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit

final class HistoryViewController: ViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    
//     VegaFlowLayoutのようにカードみたいなコレクションビューを目指す
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth - 12, height: 87)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = UIColor.white
        v.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        v.dataSource = self
        v.delegate = self
        view.addSubview(v)
        return v
    }()
    
//    lazy var emptyLabel: UILabel = {
//        let v = UILabel()
//        v.numberOfLines = 0
//        v.text = "過去の診断がありません"
//        v.font = UIFont(name: "GillSans", size: 28)
//        view.addSubview(v)
//        return v
//    }()
    lazy var backButton: UIBarButtonItem = {
        let v = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        return v
    }()
    
    override func loadView() {
        super.loadView()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    override func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        emptyLabel.snp.makeConstraints { make in
//            make.size.equalTo(300)
//            make.center.equalToSuperview()
//        }
    }
    
    
}

extension HistoryViewController {
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension HistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: HistoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HistoryCollectionViewCell else { fatalError() }
        return cell
    }


}

extension HistoryViewController: UICollectionViewDelegate {

}
