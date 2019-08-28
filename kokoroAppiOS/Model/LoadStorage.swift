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
    var name: String?
    var imageURL: URL?
    func fetchUserData() -> Observable<Profile> {
        
        return Observable<Profile>.create { observer -> Disposable in
            
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
                let profile = Profile(name: name!, imageURL: imageURL!)
                observer.onNext(profile)
                observer.onComplete()
            }
            return Disposable.create {
                
            }
        }
    }
}
