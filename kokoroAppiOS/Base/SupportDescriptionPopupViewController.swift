//
//  SupportDescriptionPopupViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/07/17.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit

final class SupportDescriptionPopupViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    
    lazy var alartImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "alart"))
        view.addSubview(v)
        return v
    }()
    
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.text = "お伝えしたいこと"
        v.font = UIFont(name: "GillSans-Bold", size: 20)
        v.textColor = UIColor.appColor(.character)
        view.addSubview(v)
        return v
    }()
    
    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.96, alpha: 0.9)
        v.layer.cornerRadius = 10
        v.layer.shadowColor = UIColor.appColor(.gray).cgColor
        v.layer.shadowRadius = 10
        v.layer.shadowOffset = CGSize(width: 20, height: 20)
        view.addSubview(v)
        return v
    }()
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.contentSize = CGSize(width: screenWidth - 30, height: 250)
        contentView.addSubview(v)
        return v
    }()
    
    lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.text =
        """
        もし、行ってみたが相談した相手にわかってもらえなかった、対応が悪かった、など、せっかく前に一歩踏み出したのに良い結果が出なかった場合、それはあなたのせいでは決してありませんし、そこで絶望する必要は全くありません。人と人の関わりにもなるので、合う合わないの相性もあります｡ﾟ(>_<)ﾟ｡\n同じ「精神科/心療内科/カウンセラー/保健所」というジャンルの人でも、与えてくれる言葉や診断は異なることも充分あり得ます。しかし、今の辛い状況を我慢する、放置することは、あなた自身にとって一番苦しいことです。1人で解決できる問題ではないからです。
        あなたを救うための機関や専門家が沢山います。\n
        このアプリを作った目的は、苦しんでいたり悩んでいる貴方が、なるべく苦労せず自分に合った窓口を選ぶためです。必ず悩みが解決するとは言えませんが、一方踏み出しやすくなって頂けたら幸いです。\n
        
        心の状態は変わります。その時の貴方がどこに行くのがいいのか、それも変わるかもしれません。思いついた時に、診断してみて、気が向いたらでもいいので、足を運んでみてください。
        貴方の心が少しでも、楽になりますように。
        """
        v.numberOfLines = 0
        v.textAlignment = .center
        v.sizeToFit()
        scrollView.addSubview(v)
        return v
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        preferredContentSize = CGSize(width: 375, height: 420)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
        scrollView.flashScrollIndicators()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.appColor(.white)
    }
    
    func makeConstraints() {
        alartImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(alartImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.width.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalToSuperview().offset(-20)
        }
    }
}
