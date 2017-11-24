//
//  ProfileHeaderCVCell.swift
//  Watcher
//
//  Created by Rj on 23/11/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

protocol ProfileHeaderCVCellDelegate {
    func didTapMovies(cell: ProfileHeaderCVCell)
    func didTapSeries(cell: ProfileHeaderCVCell)
    func didTapAnimes(cell: ProfileHeaderCVCell)
}

class ProfileHeaderCVCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var movieView: UIView!
    @IBOutlet weak var seriesView: UIView!
    @IBOutlet weak var animeView: UIView!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var animeLabel: UILabel!
    
    var delegate: ProfileHeaderCVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoImageView.setImageFrom(url: "https://dontfeedthegamers.com/wp-content/uploads/2017/03/vr-guy.jpg")
    
        photoImageView.round()
        movieLabel.round()
        seriesLabel.round()
        animeLabel.round()
        
        movieView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedMovies)))
        seriesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedSeries)))
        animeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedAnimes)))
    }
    
    @objc func tappedMovies() {
        delegate?.didTapMovies(cell: self)
    }
    
    @objc func tappedSeries() {
        delegate?.didTapSeries(cell: self)
    }
    
    @objc func tappedAnimes() {
        delegate?.didTapAnimes(cell: self)
    }
}
