//
//  SignUpViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/22.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Kingfisher


final class SignUpViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.isPagingEnabled = true
        v.showsHorizontalScrollIndicator = false
        v.delegate = self
        v.contentSize = CGSize(width: self.view.frame.size.width * 3, height: 200)
        view.addSubview(v)
        return v
    }()
    
    lazy var firstIntroView: FirstIntroView = {
        let v = FirstIntroView(frame: CGRect(x: 0, y: 0, width:
            view.frame.size.width, height: view.frame.size.height))
        return v
    }()
    
    lazy var secondIntroView: SecondIntroView = {
        let v = SecondIntroView(frame: CGRect(x: view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        return v
    }()
    
    lazy var thirdIntroView: ThirdIntroView = {
        let v = ThirdIntroView(frame: CGRect(x: view.frame.size.width * 2, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        v.delegate = self
        return v
    }()
    
    func addIntroviews() {
        let introViews = [firstIntroView, secondIntroView, thirdIntroView]
        introViews.forEach { scrollView.addSubview($0) }
    }
    
    lazy var pageControll: UIPageControl = {
        let v = UIPageControl()
        v.numberOfPages = 3
        v.pageIndicatorTintColor = UIColor.white
        v.currentPageIndicatorTintColor = UIColor.appColor(.yesPink)
        view.addSubview(v)
        return v
    }()
    
    private let screenWidth = UIScreen.main.bounds.width
    
    private let viewModel = SignUpViewModel()
    
    override func loadView() {
        super.loadView()
        setupView()
        addIntroviews()
        makeConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.layer.removeAllAnimations()
    }
    
    func setupView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.appColor(.gray)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.navbar)
        view.backgroundColor = UIColor.appColor(.background)
    }
    
    func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pageControll.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
}


extension SignUpViewController {
}

extension SignUpViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControll.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}

extension SignUpViewController: ThirdIntroViewDelegate {
    func twitterLoginButtonTapped() {
        viewModel.loginTwitter()
    }
}
