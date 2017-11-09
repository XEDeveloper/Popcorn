//
//  DetailsController.swift
//  Watcher
//
//  Created by Rj on 23/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class DetailsController: UIViewController {

    @IBOutlet weak var backdropPhoto: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movideDetailsView: UIView!
    let headerView = UIView()
    
    var menuSegmented: UISegmentedControl!
    var items: [NSDictionary] = []
    
    var movie: MovieDetail!
    
    var videos: [NSDictionary] = []
    var seasons: [NSDictionary] = []
    var casts: [NSDictionary] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if movie != nil {
            print(movie.id!)
            backdropPhoto.setImageFrom(url: moviePhoto(isCover: true))
            backgroundImageView.setImageFrom(url: moviePhoto(isCover: false))
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            ratingLabel.text = "\(String(format: "%.1f", movie.vote_average!))"
            dateLabel.text = movie.release_date
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundImageView.addSubview(blurEffectView)
            
            fireShowDetails()
        }
        
        let bgView = UIView(frame: CGRect(x: 4, y: 4, width: backButton.bounds.width - 8, height: backButton.bounds.height - 8))
        bgView.backgroundColor = .black
        bgView.alpha = 0.5
        bgView.layer.zPosition = -1
        bgView.isUserInteractionEnabled = false
        bgView.layer.cornerRadius = bgView.bounds.width / 2
        backButton.addSubview(bgView)
        
        let loader = UIActivityIndicatorView(activityIndicatorStyle: .white)
        loader.color = .orange
        loader.startAnimating()
        tableView.tableFooterView = loader
        
        menuSegmented = UISegmentedControl(items: ["Videos", "Seasons", "Cast"])
        menuSegmented.tintColor = .orange
        menuSegmented.selectedSegmentIndex = 0
        menuSegmented.addTarget(self, action: #selector(segmentedChanged), for: .valueChanged)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = menuSegmented.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.zPosition = -2
        menuSegmented.addSubview(blurEffectView)
        
        tableView.tableHeaderView = movideDetailsView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
//        return UIScreen.main.nativeBounds.height >= 2436 ? false : true
    }
    
    @objc func segmentedChanged() {
        tableView.reloadData()
    }
    
    func moviePhoto(isCover: Bool) -> String {
        
        if isCover {
            return movie.backdrop_path != nil ? movie.backdrop_path! : movie.poster_path!
        } else {
            return movie.poster_path != nil ? movie.poster_path! : movie.backdrop_path!
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func details() -> String {
        var detailsString = "videos"
        detailsString = detailsString + ",seasons"
        
        return detailsString
    }
    
    func fireShowDetails() {
        
        if let movieID = movie.id {
            let manager = APIManager()
            manager.getShowDetails(id: movieID, details: details(), onSuccess: { json in
//                print(json)
                let results = json["videos"]["results"].array
                for item in results! {
                    self.videos.append(["title": item["name"].stringValue, "link": item["key"].stringValue])
                }
                
                let genres = json["genres"].array
                for genre in genres! {
                    if self.genresLabel.text != "" {
                        self.genresLabel.text = self.genresLabel.text! + ", "
                    }
                    self.genresLabel.text = self.genresLabel.text! + genre["name"].string!
                }
                
                if Default.isSeries() {
                    let seasons = json["seasons"].array
                    if seasons![0]["season_number"] == 0 {
                        for season in seasons! {
                            self.seasons.append(["season": season["season_number"].int! + 1, "episode": season["episode_count"].int!, "poster": season["poster_path"].stringValue, "air_date": season["air_date"].stringValue])
                        }
                    } else {
                        for season in seasons! {
                            self.seasons.append(["season": season["season_number"].int!, "episode": season["episode_count"].int!, "poster": season["poster_path"].stringValue, "air_date": season["air_date"].stringValue])
                        }
                    }
                }
                
                self.tableView.tableFooterView = UIView()//self.menuSegmented
                self.tableView.reloadData()
                
            }, onFailure: { error in
                print(error)
            })
        } else {
            print("no id")
        }
    }
    
    func playVideo(withIndex index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.title = videos[index].object(forKey: "title") as? String
        vc.link = "https://m.youtube.com/watch?v=\(videos[index].object(forKey: "link") as! String)"
        let root = UINavigationController(rootViewController: vc)
        present(root, animated: true, completion: nil)
    }
    
}

extension DetailsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuSegmented != nil {
            switch menuSegmented.selectedSegmentIndex {
            case 0:
                return videos.count
            case 1:
                return seasons.count
            case 2:
                return casts.count
            default:
                return 0
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "identifier")
        
        if menuSegmented.selectedSegmentIndex == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideosTVCell", for: indexPath) as! VideosTVCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.nameLabel.text = (videos[indexPath.row]["title"] as! String)
            
            return cell
        } else if menuSegmented.selectedSegmentIndex == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonTVCell", for: indexPath) as! SeasonTVCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            let season = seasons[indexPath.row]
            var poster = (season["poster"] as! String)
            poster.remove(at: poster.startIndex)
            cell.photoImageview.setImageFrom(url: "/" + poster, with: true)
            cell.seasonLabel.text = "Season " + String(season["season"] as! Int)
            cell.episodeLabel.text = "Number of Episodes: " + String(season["episode"] as! Int)
            cell.dateLabel.text = "Air Date: " + (season["air_date"] as! String)
            return cell
            
        } else if menuSegmented.selectedSegmentIndex == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CastTVCell", for: indexPath) as! CastTVCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return menuSegmented
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if menuSegmented != nil {
            switch menuSegmented.selectedSegmentIndex {
            case 0:
                return 44.0
            case 1:
                return 111.0
            case 2:
                return 44.0
            default:
                return 0
            }
        }
        
        return 44.0
    }
    
}

extension DetailsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(withIndex: indexPath.row)
    }
    
}
