//
//  ProfileHeaderCVCell.swift
//  Watcher
//
//  Created by Rj on 23/11/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

protocol ProfileHeaderCVCellDelegate {
    func didTapRecommended(cell: ProfileHeaderCVCell)
    func didTapWatchingSoon(cell: ProfileHeaderCVCell)
    func didTapMovies(cell: ProfileHeaderCVCell)
    func didTapSeries(cell: ProfileHeaderCVCell)
    func didTapAnimes(cell: ProfileHeaderCVCell)
}

class ProfileHeaderCVCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var moviesView: UIView!
    @IBOutlet weak var seriesView: UIView!
    @IBOutlet weak var animesView: UIView!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var animeLabel: UILabel!
    
    var delegate: ProfileHeaderCVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoImageView.setImageFrom(url: "https://dontfeedthegamers.com/wp-content/uploads/2017/03/vr-guy.jpg")
    
        photoImageView.round()
        photoImageView.border(width: 5, color: .orange)
        
//        movieView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedMovies)))
//        seriesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedSeries)))
//        animeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedAnimes)))
    }
    
    @IBAction func recommendedAction(_ sender: UIButton) {
        delegate?.didTapRecommended(cell: self)
    }
    
    @IBAction func watchingSoonAction(_ sender: UIButton) {
        delegate?.didTapWatchingSoon(cell: self)
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
