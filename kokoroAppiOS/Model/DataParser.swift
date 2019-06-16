//
//  DataParser.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import APIKit

final class DecodableDataParser: DataParser {
    var contentType: String? {
        return "application/json"
    }
    
    func parse(data: Data) throws -> Any {
        return data
    }
}

