//
//  ViewController.swift
//  SDDemo
//
//  Created by José Ferré on 21/7/17.
//  Copyright © 2017 José Ferré. All rights reserved.
//

import UIKit
import RealmSwift

class MoviesVC: UIViewController {
    
    // MARK: - IBOUTLETS

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!
    
    // MARK: - Properties
    
    var movies = Array<Movie>()
    var searchBar: UISearchBar? = nil
    let interItemSpacing: CGFloat = 8.0
    var lastSearch = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        requestMovies(director: lastSearch)
        setupSearchBar()
        setupTabBar()
        set3DTouch()
    }
    
    func requestMovies(director: String) {
        
        APICtrl.requestMovies(fromDirector: director) { movies, error in
            
            self.movies.removeAll()
            
            self.movies = movies ?? []
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "segueIDMovieDetail":
            
            if let item = sender as? MovieCVCell {
                
                if let indexPath = collectionView.indexPath(for: item) {
                    
                    if let destinationVC = segue.destination as? MovieDetailVC {
                        
                        let movie = movies[indexPath.item]
                        
                        destinationVC.movie = movie
                        destinationVC.moviePoster = item.imgPoster.image
                        
                        let backItem = UIBarButtonItem()
                        backItem.title = ""
                        navigationItem.backBarButtonItem = backItem
                    }
                }
            }

        default: break
        }
    }
}

extension MoviesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCVCell.REUSE_ID,
                                                      for: indexPath) as! MovieCVCell
        cell.setupCell(withMovie: movies[indexPath.item],
                       delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing * 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(interItemSpacing, interItemSpacing, interItemSpacing + 49.0, interItemSpacing)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { context in
            
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.layoutSubviews()
            
        }) { context in /* EMPTY ATM */ }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsForRow: CGFloat = UIApplication.shared.statusBarOrientation.isPortrait ? 2.0 : 4.0
        let width: CGFloat = (collectionView.bounds.width - interItemSpacing) / itemsForRow - interItemSpacing
        
        return CGSize(width: width, height: 275)
    }
}

extension MoviesVC: UISearchBarDelegate {
    
    fileprivate func setupSearchBar() {
        
        navigationController?.hidesBarsOnSwipe = true
        searchBar = UISearchBar()
        searchBar?.sizeToFit()
        searchBar?.delegate = self
        
        navigationItem.titleView = searchBar
        searchBar?.backgroundColor = UIColor.clear
        
        // Set Textfield inside searchbar
        let textFieldInsideSearchBar = searchBar?.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.flatBlack
        textFieldInsideSearchBar?.backgroundColor = .clear
        
        // Set searchbar textfield hint
        let attributeDict = [NSForegroundColorAttributeName: UIColor.flatBlack]
        textFieldInsideSearchBar!.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: attributeDict)
        (UIBarButtonItem.appearance(whenContainedInInstancesOf: ([UISearchBar.self])).tintColor = UIColor.flatBlack)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar?.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.searchBar(searchBar, textDidChange: "")
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { /* EMPTY ATM */ }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        lastSearch = searchBar.text ?? ""
        requestMovies(director: lastSearch)
        tabBar.selectedItem = tabBar.items?.first
    }
    
}

extension MoviesVC: MovieCellDelegate {
    
    func btnFavPressed(cell: MovieCVCell) {
     
        if  let indexPath = self.collectionView.indexPath(for: cell) {
            
            let movie = self.movies[indexPath.item]
            
            if let dbMovie = try! Realm().object(ofType: Movie.self, forPrimaryKey: movie.showID) {
                
                guard movie.realm != nil else {
                    
                    movie.favorited = false
                    RealmHelper.deleteSingleObj(obj: dbMovie)
                    collectionView.performBatchUpdates({
                        
                        self.collectionView.reloadItems(at: [indexPath])
                        
                    }, completion: nil)
                    
                    return
                }
                
                RealmHelper.deleteSingleObj(obj: dbMovie)
                self.movies.remove(at: indexPath.item)
                
                collectionView.performBatchUpdates({
                    
                    self.collectionView.reloadSections([0])
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    
                }, completion: nil)
                
            } else {
                
                movie.favorited = true
                RealmHelper.insertOrUpdateObj(obj: movie, Movie.self)
                
                collectionView.performBatchUpdates({
                    
                    self.collectionView.reloadItems(at: [indexPath])
                    
                }, completion: nil)
            }
        }
    }
}

extension MoviesVC: UITabBarDelegate {
    
    fileprivate func setupTabBar() {
        
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?.first
        tabBar.tintColor = UIColor.flatWatermelon
    }
    
    enum tabID: Int {
        case search
        case favorites
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch item.tag {
        case tabID.search.rawValue:
            
            requestMovies(director: lastSearch)
            navigationController?.setNavigationBarHidden(false, animated: true)
            
        case tabID.favorites.rawValue:
            
            movies.removeAll()
            if let favoritedMovies = RealmHelper.getRealmObjects(ofType: Movie.self)?.filter("favorited == true") {
                movies = Array(favoritedMovies)
            }
            
        default: break
        }
        
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension MoviesVC: UIViewControllerPreviewingDelegate {
    
    func set3DTouch() {
        
        if (traitCollection.forceTouchCapability == .available) {
            
            registerForPreviewing(with: self, sourceView: self.collectionView)
        }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = self.collectionView!.indexPathForItem(at: location) else { return nil }
        guard let cell = self.collectionView!.cellForItem(at: indexPath) as? MovieCVCell else { return nil }
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: MovieDetailVC.SB_ID) as? MovieDetailVC else { return nil }
        
        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.centeredVertically)
        
        detailVC.movie = movies[indexPath.item]
        detailVC.moviePoster = cell.imgPoster.image
        
        detailVC.preferredContentSize = CGSize(width: 0.0, height: self.view.bounds.height * 0.75)
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}


