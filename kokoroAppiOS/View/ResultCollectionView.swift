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


enum SelectedAnswers: String {
    case yes = "YES"
    case no = "NO"
    
    func selectedColor() -> UIColor {
        switch self {
        case .yes: return UIColor.appColor(.yesPink)
        case .no: return UIColor.appColor(.noBlue)
        }
    }
}

final class ResultCollectionView: UIView {
    
//    var selectedColor: UIColor {
//        switch SelectedAnswers {
//        case .yes: return UIColor.appColor(.yesPink)
//        case .no: return UIColor.appColor(.no)
//        }
//    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: screenWidth - 24, height: 87)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = UIColor.appColor(.background)
        v.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        v.dataSource = self
        v.delegate = self
        addSubview(v)
        return v
    }()
    
    let screenWidth = UIScreen.main.bounds.width
    var numberIndex = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    var questions = [String]()
    var selectedAnswers = [SelectedAnswers]()
    
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

extension ResultCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ResultCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as?
            ResultCollectionViewCell else { fatalError() }
        cell.questionIndexLabel.text = numberIndex[indexPath.row]
        cell.questionLabel.text = questions[indexPath.row]
        cell.answerLabel.text = "A: \(selectedAnswers[indexPath.row].rawValue)"
        cell.answerLabel.textColor = SelectedAnswers.selectedColor(selectedAnswers[indexPath.row])()
        return cell
    }
}

extension ResultCollectionView: UICollectionViewDelegate {
    
}
