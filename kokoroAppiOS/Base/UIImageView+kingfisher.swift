//
//  View.swift
//  practice_Mousou
//
//  Created by 中野湧仁 on 2019/03/31.
//  Copyright © 2019 中野湧仁. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {

    func setImage(with urlString: String?, completion: ((UIImage?) -> Void)? = nil) {
        guard
            let urlString = urlString,
            let imageURL = URL(string: urlString)
            else {
                self.image = nil
                return
        }
        self.setImage(with: imageURL, completion: completion)
    }

    func setImage(with url: URL?, completion: ((UIImage?) -> Void)? = nil) {
        guard let url = url else {
            self.image = nil
            return
        }
        self.kf.setImage(
            with: url,
            placeholder: nil,
            options: [.transition(.fade(0.3))],
            progressBlock: nil,
            completionHandler: { dlimg, _, _, _ in
                completion?(dlimg)
            }
        )
    }

}
