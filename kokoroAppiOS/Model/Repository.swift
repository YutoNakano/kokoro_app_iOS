//
//  Repository.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/06/16.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation

struct Question: Decodable {
    let id: Int
    let title: String
    let description: String
    let comment: String?
    let status: Bool?
    let imageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case comment
        case status
        case imageURL = "image_url"
    }
}

struct Result: Decodable {
    let id: Int
    let title: String
    let description: String
    let comment: String?
    let status: Bool?
    let imageURL: String?
    let url: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case comment
        case status
        case imageURL = "image_url"
        case url
    }
}
