//
//  ViewController.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import APIKit

class ViewController: UIViewController {

    @IBOutlet weak var apiLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Session.send(QuestionResponse.SearchRepositories()) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }


        Session.send(ResultResponse.SearchRepositories()) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
        
    }


}

