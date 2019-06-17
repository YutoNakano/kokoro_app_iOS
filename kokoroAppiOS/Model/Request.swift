//
//  Request.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import APIKit

protocol KokoroApp: Request {
    
}

extension KokoroApp {
    var baseURL: URL {
        return URL(string: "http://958e6b31.ngrok.io")!
    }
}

extension KokoroApp where Response: Decodable {
    var dataParser: DataParser {
        return DecodableDataParser()
    }
    
//    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
//        guard let data = object as? Data else {
//            throw ResponseError.unexpectedObject(object)
//        }
//        return try JSONDecoder().decode(Response.self, from: data)
//    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
