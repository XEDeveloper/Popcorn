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
    
    var movie: MovieDetail!
    
    var videos: [NSDictionary] = []
//    var videos: [String] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if movie != nil {
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
            
            fireVideos()
        }
        
        let bgView = UIView(frame: CGRect(x: 4, y: 4, width: backButton.bounds.width - 8, height: backButton.bounds.height - 8))
        bgView.backgroundColor = .black
        bgView.alpha = 0.5
        bgView.layer.zPosition = -1
        bgView.isUserInteractionEnabled = false
        bgView.layer.cornerRadius = bgView.bounds.width / 2
        backButton.addSubview(bgView)
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
    
    func fireVideos() {
        
        if let movieID = movie.id {
            let manager = APIManager()
            manager.getMovieVideos(id: movieID, onSuccess: { json in
                let results = json["results"].array
                var ctr = 1
                for item in results! {
                    self.videos.append(["title": item["name"].stringValue, "link": item["key"].stringValue])
                    let videoLabel = UILabel(frame: CGRect(x: 16.0, y: CGFloat(25 * ctr) + self.dateLabel.frame.maxY, width: UIScreen.main.bounds.width - 16.0, height: 20.0))
                    videoLabel.text = "Watch \(item["name"].stringValue)"
                    videoLabel.textColor = .white
                    videoLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
                    videoLabel.tag = ctr - 1
                    videoLabel.isUserInteractionEnabled = true
                    videoLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tappedLink(_:))))
                    self.view.addSubview(videoLabel)
                    ctr += 1
                }
            }, onFailure: { error in
                print(error)
            })
        } else {
            print("no id")
        }
    }
    
    @objc func tappedLink(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.title = videos[(sender.view?.tag)!].object(forKey: "title") as? String
        vc.link = "https://m.youtube.com/watch?v=\(videos[(sender.view?.tag)!].object(forKey: "link") as! String)"
        let root = UINavigationController(rootViewController: vc)
        present(root, animated: true, completion: nil)
    }
    
    func playTrailer() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
//        vc.title = videos.object(forKey: "title") as? String
//        vc.link = "https://m.youtube.com/watch?v=\(videos?.object(forKey: "link") as! String)"
//        let root = UINavigationController(rootViewController: vc)
//        present(root, animated: true, completion: nil)
    }
    
}
