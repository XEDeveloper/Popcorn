//
//  Category.swift
//  Watcher
//
//  Created by Rj on 20/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit
import Kingfisher

class Category: NSObject {

}

extension UIViewController {
    
}

extension UIImageView {
    
    func setImageFrom(url: String, with indicator: Bool = false) {
        
        self.kf.indicatorType = .activity
        if url.range(of: "tmdb") == nil {
            self.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + url))
        } else {
            self.kf.setImage(with: URL(string: url))
        }
    }
    
}
