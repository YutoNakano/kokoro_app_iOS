//
//  ResultCollectionView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/24.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class ResultCollectionView: UIView {
    
    let screenWidth = UIScreen.main.bounds.width
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: screenWidth - 24, height: 87)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = UIColor.appColor(.background)
        v.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        v.dataSource = self
        v.delegate = self
        addSubview(v)
        return v
    }()
    
    var numberIndex = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    
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

extension ResultCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ResultCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as?
            ResultCollectionViewCell else { fatalError() }
        cell.questionIndexLabel.text = numberIndex[indexPath.row]
        return cell
    }
}

extension ResultCollectionView: UICollectionViewDelegate {
    
}
