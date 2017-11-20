//
//  RecordsController.swift
//  Watcher
//
//  Created by Rj on 10/11/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

class RecordsController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var shows: [MovieDetail] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Watched Shows"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tappedClose))
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.barTintColor = .black
        
        let data = DataManager.fetchData()
        for show in data {
            let movie = MovieDetail(data: show)
            shows.append(movie)
        }
    }
    
    @objc func tappedClose() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension RecordsController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listId", for: indexPath) as! ListCVCell
        
        cell.photo.setImageFrom(url: shows[indexPath.row].poster_path!)
        
        return cell
    }
}

extension RecordsController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "detailsVC") as! DetailsController
            vc.movie = shows[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
    }
}

extension RecordsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (UIScreen.main.bounds.width / 3) - 2
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
