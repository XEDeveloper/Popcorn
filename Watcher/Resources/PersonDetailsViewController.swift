//
//  PersonDetailsViewController.swift
//  Watcher
//
//  Created by Rj on 21/11/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit
import SafariServices

class PersonDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthPlaceLabel: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var imdbButton: UIButton!
    
    var person: PersonDetail!
    
    var shows: [MovieDetail] = []
    var lastContentOffset: CGFloat = 0.0
    
    var isFullBiography = false
    
    var tableHeaderView = UIView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = .orange
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tappedClose))
        
        backgroundImageView.setImageFrom(url: person.photo!)
        backgroundImageView.blur()
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0)
        
        firePersonDetails()
        biographyLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedBiography)))
    }
    
    func firePersonDetails(withShows: Bool = false) {
        
        let manager = APIManager()
        manager.getPersonDetails(id: person.id!, shows: withShows, onSuccess: { json in
            
            if withShows {
                let casts = json["cast"].array
                for item in casts! {
                    self.shows.append(MovieDetail(json: item))
                }
                self.tableView.reloadData()
            } else {
                self.person = PersonDetail(json: json)
                
                self.profilePhoto.setImageFrom(url: self.person.photo!)
                self.nameLabel.text = self.person.name!
                self.birthDayLabel.text = self.person.birthday!
                self.birthPlaceLabel.text = self.person.place_of_birth!
                self.biographyLabel.text = self.person.biography!
                self.imdbButton.isHidden = false
                
                self.firePersonDetails(withShows: true)
            }
            
        }, onFailure: { error in
            print(error)
        })
    }
    
    @objc func tappedBiography() {
//        isFullBiography = isFullBiography ? false : true
        
        if isFullBiography {
            isFullBiography = false
            biographyLabel.frame.size.height = 90.0
            headerView.frame.size.height = 284.0
        } else {
            isFullBiography = true
            biographyLabel.sizeToFit()
            headerView.frame.size.height = biographyLabel.frame.maxY + 10.0
        }
        
        tableView.reloadData()
    }
    
    @objc func tappedClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openIMDBAction(_ sender: UIButton) {
        let safariVC = SFSafariViewController(url: URL(string: "http://www.imdb.com/name/\(person.imdb_id!)/")!)
        self.present(safariVC, animated: true, completion: nil)
    }

}

extension PersonDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFullBiography ? 0 : shows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "identifier")
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath) as! PersonShowsTVCell
        cell.selectionStyle = .none
        let movie = shows[indexPath.row]
        
        cell.profileIImageView.setImageFrom(url: movie.poster_path!, with: true)
        cell.titleLabel.text = movie.title
        cell.characterLabel.text = "as " + movie.character!
        cell.overviewLabel.text = movie.overview
        
        return cell
    }
}

extension PersonDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailsVC") as! DetailsController
        vc.movie = shows[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PersonDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.lastContentOffset > scrollView.contentOffset.y || scrollView.contentOffset.y == -64.0 {
            // uping
            if scrollView.contentOffset.y < 110.0 && title != nil {
                self.title = nil
                self.navigationItem.rightBarButtonItem = nil
            }
        } else if self.lastContentOffset < scrollView.contentOffset.y {
            // downing
            if scrollView.contentOffset.y >= 110.0 && title == nil {
                self.title = "Movies And TV Shows"
                let photo = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
                photo.image = self.backgroundImageView.image
                photo.layer.cornerRadius = photo.frame.size.width / 2
                photo.layer.borderWidth = 2.0
                photo.layer.borderColor = UIColor.orange.cgColor
                photo.clipsToBounds = true
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: photo)
            }
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
}

