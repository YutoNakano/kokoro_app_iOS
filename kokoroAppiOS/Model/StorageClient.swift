//
//  StorageClient.swift
//  kokoroAppiOS
//
//  Created by 中野湧仁 on 2019/08/28.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import RxSwift
import RxCocoa

final class StorageClient {
    let defaultImageURLString = "https://camo.qiitausercontent.com/d56e40010b0f495b8248be39742e500244892fe0/68747470733a2f2f61766174617273312e67697468756275736572636f6e74656e742e636f6d2f752f363430373034313f763d3426733d343030"

    var imageURL: URL?
    var name: String?
    func fetchUserData(completion: (Profile) -> Void) {
        if let user = Auth.auth().currentUser {
            let userRef = Firestore.firestore().collection("users").document(user.uid)
            userRef.getDocument(completion: { [weak self](document, error) in
                if let document = document, document.exists {
                    let profileImageUrl = document["profileImageUrl"]
                    let name = document["name"]
                    guard let urlString = profileImageUrl as? String else { return }
                    if let url = URL(string: urlString) {
                        do {
                            self?.imageURL = url
                            self?.name = name as! String
                        } catch let err {
                            print(err)
                        }
                    }
                }
            })
        }
        print(name)
        print(imageURL)
        guard let name = name, let url = imageURL else { return }
        completion(Profile(name: name, imageURL: url))
    }
}
