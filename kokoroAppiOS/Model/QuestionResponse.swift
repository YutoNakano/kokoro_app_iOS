//
//  QuestionResponse.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import APIKit

final class QuestionResponse {
    private init() {}
    
    struct SearchRepositories: KokoroApp {
        typealias Response = Question
        
        let method: HTTPMethod = .get
        let path: String = "/api/questions/1/"
        //        var parameters: Any? {
        //            return ["q": query, "page": 1]
        //        }
        
        //        let query: String
    }
}
