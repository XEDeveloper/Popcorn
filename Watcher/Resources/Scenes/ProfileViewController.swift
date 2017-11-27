
//
//  ProfileViewController.swift
//  Watcher
//
//  Created by Rj on 23/11/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let manager = APIManager()
    var page = 1
    var hasPendingRequest = false
    var shows: [MovieDetail] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tappedClose))
        collectionView.registerCell(withName: "ProfileHeaderCVCell")
        
        fireShows()
        
    }

    @objc func tappedClose() {
        dismiss(animated: true, completion: nil)
    }
    
    func fireShows() {
        hasPendingRequest = true
        manager.fetchShows(withPage: page, onSuccess: { json in
            let results = json["results"].array
            for item in results! {
                let movie = MovieDetail(json: item)
                self.shows.append(movie)
            }
            self.page += 1
            self.collectionView.reloadData()
            self.hasPendingRequest = false
        }, onFailure: { error in
            let alert = UIAlertController(title: "Ooopps!", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileHeaderCVCell", for: indexPath) as! ProfileHeaderCVCell
            cell.delegate = self
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listId", for: indexPath) as! ListCVCell
            cell.photo.setImageFrom(url: shows[indexPath.row].poster_path!)
            
            return cell
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailsVC") as! DetailsController
        vc.movie = shows[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.size.width, height: 312.0)//collectionView.bounds.size.width * 0.75)
        }
        
        let width = (UIScreen.main.bounds.width / 3) - 1
        return CGSize(width: width, height: width + (width * 0.35))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

extension ProfileViewController: ProfileHeaderCVCellDelegate {
    
    func didTapRecommended(cell: ProfileHeaderCVCell) {
        self.presentListController(withTitle: "Recommended Shows", shows: shows)
    }
    
    func didTapWatchingSoon(cell: ProfileHeaderCVCell) {
        self.presentListController(withTitle: "Watching Soon", shows: shows)
    }
    
    func didTapMovies(cell: ProfileHeaderCVCell) {
        Default.setIsSeries(false)
        shows.removeAll()
        page = 1
        fireShows()
    }
    
    func didTapSeries(cell: ProfileHeaderCVCell) {
        Default.setIsSeries(true)
        shows.removeAll()
        page = 1
        fireShows()
    }
    
    func didTapAnimes(cell: ProfileHeaderCVCell) {
        Default.setIsSeries(false)
        shows.removeAll()
        page = 1
    }
}
