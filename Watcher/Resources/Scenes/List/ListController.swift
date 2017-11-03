//
//  ListController.swift
//  Watcher
//
//  Created by Rj on 19/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ListControllerInput {
    
}

protocol ListControllerOutput {
    func fetchItems(request: ListModel.Fetch.Request)
}

class ListController: UIViewController, ListControllerInput {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let searchBar = UISearchBar()
    let manager = APIManager()
    
    var page = 1
    var hasPendingRequest = false
    
    var selectedItems = 0
    var movies: [MovieDetail] = []
    
    //
    var output: ListControllerOutput!
    var router: ListRouter!
    //
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ListConfigurator.sharedInstance.configure(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(tappedFilter))
        navigationController?.navigationBar.tintColor = .orange
        
        searchBar.sizeToFit()
        searchBar.placeholder = "Type title here..."
        searchBar.barStyle = .blackTranslucent
        searchBar.delegate = self
        searchBar.keyboardAppearance = .dark
        navigationItem.titleView = searchBar
        
//        output.fetchItems(request: ListModel.Fetch.Request(itemId: 123))
        
        if Default.isSeries() {
            fireSeries()
        } else {
            fireMovies()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .compact)
    }

    @objc func tappedFilter() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterController") as! FilterController
        vc.delegate = self
        present(vc, animated: false, completion: nil)
    }
    
    func tappedClear() {
        selectedItems = 0
    }

    func resetRequest() {
        hasPendingRequest = true
    }
    
    func fireMovies() {
        resetRequest()
        manager.fetchMoviesWithPage(page: page, onSuccess: { json in
            self.extract(json)
        }, onFailure: { error in
            print(error)
        })
    }
    
    func fireSearchMovie(withKeyword key: String) {
        resetRequest()
        manager.searchMoviesWithText(keyword: key, page: page, onSuccess: { json in
            self.extract(json)
        }, onFailure: { error in
            print(error)
        })
    }
    
    func extract(_ json: JSON) {
        let results = json["results"].array
        for item in results! {
            let movie = MovieDetail(json: item)
            self.movies.append(movie)
        }
        self.page += 1
        self.collectionView.reloadData()
        self.hasPendingRequest = false
    }

    func fireSeries() {
        resetRequest()
        manager.fetchSeriesWithPage(page: page, onSuccess: { json in
            self.extract(json)
        }, onFailure: { error in
            print(error)
        })
    }
}

extension ListController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listId", for: indexPath) as! ListCVCell
        
        cell.photo.setImageFrom(url: movies[indexPath.row].poster_path!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row >= movies.count - 6 && hasPendingRequest == false {
            if searchBar.text == "" {
                self.fireMovies()
            } else {
                self.fireSearchMovie(withKeyword: searchBar.text!)
            }
        }
    }
}

extension ListController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItems += 1
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailsVC") as! DetailsController
        vc.movie = movies[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (UIScreen.main.bounds.width / 3) - 10
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
        return 5.0
    }
}

extension ListController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = nil

        if searchBar.text != "" && movies.count == 0 {
            movies.removeAll()
            page = 1
            fireMovies()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        movies.removeAll()
        collectionView.reloadData()
        page = 1
        searchBar.resignFirstResponder()
        fireSearchMovie(withKeyword: searchBar.text!)
    }
}

extension ListController: FilterControllerDelegate {
    
    func didTappedSave(controller: FilterController) {
        page = 1
        movies.removeAll()
        collectionView.reloadData()
        
        if Default.isSeries() {
            fireSeries()
        } else {
            fireMovies()
        }
    }
}

// Clean Swift
extension ListController {
    
    func successFetchedItems(viewModel: ListModel.Fetch.ViewModel) {
        print(viewModel.title!)
        print(viewModel.poster_path!)
    }
    
    func errorFetchingItems(viewModel: ListModel.Fetch.ViewModel) {
        print(viewModel.message!)
    }
}


