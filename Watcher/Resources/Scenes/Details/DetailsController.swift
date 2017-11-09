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
    var menuTabs = ["Videos", "Seasons", "Casts", "Similar Shows"]
    var items: [NSDictionary] = []
    
    var movie: MovieDetail!
    
    var videos: [NSDictionary] = []
    var seasons: [NSDictionary] = []
    var casts: [NSDictionary] = []
    var similars: [NSDictionary] = []
    
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
        
        if !Default.isSeries() {
            menuTabs.remove(at: 1)
        }
        menuSegmented = UISegmentedControl(items: menuTabs)
        menuSegmented.tintColor = .orange
        menuSegmented.selectedSegmentIndex = 0
        menuSegmented.addTarget(self, action: #selector(segmentedChanged), for: .valueChanged)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = menuSegmented.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.zPosition = -2
        menuSegmented.addSubview(blurEffectView)
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
        let detailsString = "videos,credits,similar"
        return Default.isSeries() ? detailsString + ",seasons" : detailsString
    }
    
    func fireShowDetails() {
        
        if let movieID = movie.id {
            let manager = APIManager()
            manager.getShowDetails(id: movieID, details: details(), onSuccess: { json in
//                print(json["similar"])
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
                
                let casts = json["credits"]["cast"].array
                for item in casts! {
                    self.casts.append(["character": item["character"].stringValue, "actor": item["name"].stringValue, "profile_path": item["profile_path"].stringValue])
                }
                
                let similars = json["similar"]["results"].array
                for item in similars! {
                    self.similars.append(["name": item["name"].stringValue, "overview": item["overview"].stringValue, "backdrop_path": item["backdrop_path"].stringValue, "poster_path": item["poster_path"].stringValue, "vote": item["vote_average"].stringValue])
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
                
                self.tableView.tableHeaderView = self.movideDetailsView
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
    
    func gotoSeason(withIndex index: Int) {
        
    }
    
    func viewActor(withIndex index: Int) {
        
    }
    
    func gotoShow(withIndex index: Int) {
        
    }
    
}

extension DetailsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuSegmented != nil {
            switch menuTabs[menuSegmented.selectedSegmentIndex] {
            case "Videos":
                return videos.count
            case "Seasons":
                return seasons.count
            case "Casts":
                return casts.count
            default:
                return similars.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "identifier")
        
        if menuTabs[menuSegmented.selectedSegmentIndex] == "Videos" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideosTVCell", for: indexPath) as! VideosTVCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.nameLabel.text = (videos[indexPath.row]["title"] as! String)
            return cell
            
        } else if menuTabs[menuSegmented.selectedSegmentIndex] == "Seasons" {
            
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
            
        } else if menuTabs[menuSegmented.selectedSegmentIndex] == "Casts" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CastTVCell", for: indexPath) as! CastTVCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            let cast = casts[indexPath.row]
            var poster = (cast["profile_path"] as! String)
            poster.remove(at: poster.startIndex)
            cell.photoImageView.setImageFrom(url: "/" + poster, with: true)
            cell.realNameLabel.text = (cast["actor"] as! String)
            cell.characterNameLabel.text = (cast["character"] as! String)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarTVCell", for: indexPath) as! SimilarTVCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            let similar = similars[indexPath.row]
            var poster = (similar["poster_path"] as! String)
            poster.remove(at: poster.startIndex)
            cell.photoImageView.setImageFrom(url: "/" + poster, with: true)
            cell.titleLabel.text = (similar["name"] as! String)
            cell.overviewLabel.text = (similar["overview"] as! String)
            cell.rateLabel.text = (similar["vote"] as! String)
            
            return cell
        }
        
//        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return menuSegmented
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if menuSegmented != nil {
            switch menuTabs[menuSegmented.selectedSegmentIndex] {
            case "Videos":
                return 44.0
            case "Seasons":
                return 111.0
            case "Casts":
                return 111.0
            default:
                return 111.0
            }
        }
        
        return 44.0
    }
    
}

extension DetailsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if menuSegmented != nil {
            switch menuTabs[menuSegmented.selectedSegmentIndex] {
            case "Videos":
                playVideo(withIndex: indexPath.row)
                break
            case "Seasons":
                gotoSeason(withIndex: indexPath.row)
                break
            case "Casts":
                viewActor(withIndex: indexPath.row)
                break
            default:
                gotoShow(withIndex: indexPath.row)
                break
            }
        }
    }
    
}
