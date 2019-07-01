//
//  HistoryDetailCollectionView.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/29.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class HistoryDetailCollectionView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 35, right: 10)
        layout.itemSize = CGSize(width: screenWidth - 24, height: 87)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = UIColor.appColor(.background)
        v.register(HistoryDetailCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        v.dataSource = self
        v.delegate = self
        addSubview(v)
        return v
    }()
    
    let screenWidth = UIScreen.main.bounds.width
    var numberIndex = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    var questions = [String]()
    var selectedAnswersString = [String]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        makeConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
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
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: HistoryDetailCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as?
            HistoryDetailCollectionViewCell else { fatalError() }
        cell.questionIndexLabel.text = numberIndex[indexPath.row]
        cell.questionLabel.text = questions[indexPath.row]
        cell.answerLabel.text = "A: \(selectedAnswersString[indexPath.row])"
        cell.answerLabel.textColor = selectedColor(selectedAnswerString: selectedAnswersString[indexPath.row])
        return cell
    }
}

extension HistoryDetailCollectionView: UICollectionViewDelegate {
    
}

extension HistoryDetailCollectionView {
    func selectedColor(selectedAnswerString: String) -> UIColor {
        switch selectedAnswerString {
        case "YES": return UIColor.appColor(.yesPink)
        case "NO": return UIColor.appColor(.noBlue)
        default: ()
        }
        return UIColor.appColor(.yesPink)
    }
}
