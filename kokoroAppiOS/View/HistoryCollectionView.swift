//
//  HistoryCollectionView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/23.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseAuth

final class HistoryDetailCollectionView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: screenWidth - 24, height: 87)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = UIColor.appColor(.background)
        v.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        v.dataSource = self
        v.delegate = self
        addSubview(v)
        return v
    }()
    
    let screenWidth = UIScreen.main.bounds.width
    var histories: [Document<History>] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension HistoryDetailCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return histories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: HistoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as?
            HistoryCollectionViewCell else { fatalError() }
        
        cell.configure(histories: histories[indexPath.row])
        
        return cell
    }
}

extension HistoryDetailCollectionView: UICollectionViewDelegate {
    
}
