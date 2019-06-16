//
//  kokoroAPI.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import APIKit

final class ResultResponse {
    private init() {}
    
    struct SearchRepositories: KokoroApp {
        typealias Response = Result
        
        let method: HTTPMethod = .get
        let path: String = "/api/results/1/"
//        var parameters: Any? {
//            return ["q": query, "page": 1]
//        }
        
//        let query: String
    }
}
