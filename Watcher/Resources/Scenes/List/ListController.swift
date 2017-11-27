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
    @IBOutlet weak var watchedShowsView: UIView!
    
    let searchBar = UISearchBar()
    let manager = APIManager()
    
    var page = 1
    var hasPendingRequest = false
    
    var selectedItems: [MovieDetail] = []
    var shows: [MovieDetail] = []
    
    //
    var output: ListControllerOutput!
    var router: ListRouter!
    //
    
    var lastContentOffset: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ListConfigurator.sharedInstance.configure(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        normalNavigationBar()
        
//        initSearchBar()
        
//        output.fetchItems(request: ListModel.Fetch.Request(itemId: 123))
        initNavigationBar()
        fireShows()
        
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.5
        longPress.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPress)
        
        watchedShowsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showWatchedShows)))
        
//        self.presentController(withName: "ProfileViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .compact)
    }


    func initSearchBar() {
        searchBar.sizeToFit()
        searchBar.placeholder = "Type title here..."
        searchBar.barStyle = .blackTranslucent
        searchBar.delegate = self
        searchBar.keyboardAppearance = .dark
    }
    
    func normalNavigationBar() {
        selectedItems.removeAll()
        collectionView.reloadData()
        title = nil
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(tappedFilter))
        navigationItem.rightBarButtonItem = nil
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        if self.title == nil || self.title == "" {
            self.title = nil
            initSearchBar()
            navigationItem.titleView = searchBar
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(tappedFilter))
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.titleView = nil
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tappedClose))
            navigationItem.rightBarButtonItem = nil
            watchedShowsView.isHidden = true
        }
    }
    
    func selectingNavigationBar() {
        navigationItem.titleView = nil
        title = "Selected Item (\(DataManager.fetchData().count))"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelSelection))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSelection))
    }
    
    @objc func showWatchedShows() {
        self.presentController(withName: "ProfileViewController")
    }
    
    @objc func tappedClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelSelection() {
        normalNavigationBar()
        collectionView.reloadData()
    }
    
    @objc func saveSelection() {
        let alert = UIAlertController(title: "Name Please!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            self.normalNavigationBar()
//            let field = alert.textFields![0] as UITextField
//            Default.addRecord(show: selectedItems)
        }))
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Your name here obviously 🙄"
        }
        present(alert, animated: true, completion: nil)
    }
    
    @objc func tappedFilter() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterController") as! FilterController
        vc.delegate = self
        present(vc, animated: false, completion: nil)
    }

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        selectingNavigationBar()
        let p = gesture.location(in: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: p) {
            // get the cell at indexPath (the one you long pressed)
            let cell = collectionView.cellForItem(at: indexPath) as! ListCVCell
            cell.checkBgView.isHidden = false
            cell.checkImageView.isHidden = false
            if !DataManager.movieAlreadyExist(withID: shows[indexPath.row].id!) {
                DataManager.add(movie: shows[indexPath.row])
            }
            collectionView.reloadData()
        } else {
            print("couldn't find index path")
        }
    }
    
    func resetList() {
        page = 1
        shows.removeAll()
        collectionView.reloadData()
        
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    func fireSearchMovie(withKeyword key: String) {
        hasPendingRequest = true
        manager.searchMoviesWithText(keyword: key, page: page, onSuccess: { json in
            let results = json["results"].array
            for item in results! {
                let movie = MovieDetail(json: item)
                self.shows.append(movie)
            }
            self.page += 1
            self.collectionView.reloadData()
            self.hasPendingRequest = false
        }, onFailure: { error in
            print(error)
        })
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

extension ListController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listId", for: indexPath) as! ListCVCell
        
        cell.photo.setImageFrom(url: shows[indexPath.row].poster_path!)
        
        if navigationItem.titleView == nil {
            if DataManager.movieAlreadyExist(withID: shows[indexPath.row].id!) {
                cell.checkBgView.isHidden = false
                cell.checkImageView.isHidden = false
            } else {
                cell.checkBgView.isHidden = true
                cell.checkImageView.isHidden = true
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row >= shows.count - 6 && hasPendingRequest == false {
            if searchBar.text == "" {
                self.fireShows()
            } else {
                self.fireSearchMovie(withKeyword: searchBar.text!)
            }
        }
    }
}

extension ListController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if title == nil { // browsing
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "detailsVC") as! DetailsController
            vc.movie = shows[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        } else { // selecting
            
//            if selectedItems.count > 1 {
//                if selectedItems[0].id == selectedItems[1].id {
//                    selectedItems.removeFirst()
//                }
//            }
//
//            let cell = collectionView.cellForItem(at: indexPath) as! ListCVCell
//            if cell.checkBgView.isHidden {
//                cell.checkBgView.isHidden = false
//                cell.checkImageView.isHidden = false
//                selectedItems.append(shows[indexPath.row])
//            } else {
//                selectedItems = selectedItems.filter( { $0.id != shows[indexPath.row].id! } )
//                cell.checkBgView.isHidden = true
//                cell.checkImageView.isHidden = true
//            }
//
//            self.title = selectedItems.count == 0 ? "Select Shows" : "Selected Items (\(selectedItems.count))"
            
            
            if DataManager.movieAlreadyExist(withID: shows[indexPath.row].id!) {
                DataManager.deleteMovie(withId: shows[indexPath.row].id!)
            } else {
                DataManager.add(movie: shows[indexPath.row])
            }
            title = "Selected Item (\(DataManager.fetchData().count))"
            
            self.collectionView?.reloadItems(at: [IndexPath(item: indexPath.row, section: 0)])
        }
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

extension ListController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        if self.lastContentOffset > scrollView.contentOffset.y || scrollView.contentOffset.y == -64.0 {
//            // uping
//            UIView.animate(withDuration: 0.3, animations: {
//                self.watchedShowsView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
//            })
//        } else if self.lastContentOffset < scrollView.contentOffset.y {
//            // downing
//            UIView.animate(withDuration: 0.3, animations: {
//                self.watchedShowsView.transform = CGAffineTransform(translationX: 0.0, y: 48.0)
//            })
//        }
//
//        self.lastContentOffset = scrollView.contentOffset.y
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

        if searchBar.text != "" && shows.count == 0 {
            resetList()
//            fireMovies()
            fireShows()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resetList()
        fireSearchMovie(withKeyword: searchBar.text!)
    }
}

extension ListController: FilterControllerDelegate {
    
    func didTappedSave(controller: FilterController) {
        resetList()
        fireShows()
//        if Default.isSeries() {
//            fireSeries()
//        } else {
//            fireMovies()
//        }
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


