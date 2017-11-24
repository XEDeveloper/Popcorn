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

extension UIView {
    
    func round() {
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.clipsToBounds = true
    }
    
    func border(width: Int = 1, color: UIColor = .white) {
        self.layer.borderWidth = CGFloat(width)
        self.layer.borderColor = color.cgColor
    }
}

extension UIImageView {
    
    func setImageFrom(url: String, with indicator: Bool = false) {
        
        self.kf.indicatorType = .activity
        
        if url.range(of: "http") == nil {
            self.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + url))
        } else {
            self.kf.setImage(with: URL(string: url))
        }
    }
    
    func blur(dark: Bool = true) {
        let blurEffect = UIBlurEffect(style: dark ? UIBlurEffectStyle.dark : UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
}

extension UICollectionView {
    
    func registerCell(withName name: String) {
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: name)
    }
}

extension UITableView {
    
    func registerCell(withName name: String) {
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forCellReuseIdentifier: name)
    }
}

