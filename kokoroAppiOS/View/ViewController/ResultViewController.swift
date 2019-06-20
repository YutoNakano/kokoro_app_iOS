//
//  ResultViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit


final class ResultViewController: ViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    
    // VegaFlowLayoutのようにカードみたいなコレクションビューを目指す
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth - 12, height: 87)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = UIColor.white
        v.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        v.dataSource = self
        v.delegate = self
        view.addSubview(v)
        return v
    }()
    
    override func loadView() {
        super.loadView()
    }
    
    override func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
}

extension ResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ResultCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ResultCollectionViewCell else { fatalError() }
        return cell
    }
    
    
}

extension ResultViewController: UICollectionViewDelegate {
    
}

