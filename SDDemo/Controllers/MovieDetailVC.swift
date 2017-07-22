//
//  MovieDetailVC.swift
//  SDDemo
//
//  Created by Jose Ferre on 22/7/17.
//  Copyright © 2017 José Ferré. All rights reserved.
//

import UIKit
import ChameleonFramework

class MovieDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: MovieDetailHeaderView!
    
    var movie: Movie!
    var moviePoster: UIImage? = nil
    static let SB_ID = "sbIdMovieDetailVc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            
            self.headerView.viewGradient.backgroundColor = UIColor.init(gradientStyle: .topToBottom,
                                                                        withFrame: self.headerView.viewGradient.bounds,
                                                                        andColors: [UIColor.clear, UIColor.flatBlack])
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetNavBar()
    }
    
    func setupNavBar() {
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .flatBlack
    }
    
    func resetNavBar() {
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
}

extension MovieDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    enum rows: Int {
        case summary = 0
        case year
        case rating
        case category
        case director
        case showCast
        case runtime
        
        static let allValues = [summary, year, rating, category, director, showCast, runtime]
    }
    
    fileprivate func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .flatWhite
        headerView.setupView(img: moviePoster, tittle: movie.showTitle!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return rows.allValues.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailCell.REUSE_ID, for: indexPath) as! MovieDetailCell
        
        switch indexPath.row {
        case rows.summary.rawValue: cell.setupCell(title: "Summary:", body: movie.summary)
        case rows.year.rawValue: cell.setupCell(title: "Year:", body: movie.releaseYear)
        case rows.rating.rawValue: cell.setupCell(title: "Rating:", body: movie.rating)
        case rows.category.rawValue: cell.setupCell(title: "Category:", body: movie.category)
        case rows.director.rawValue: cell.setupCell(title: "Director:", body: movie.director)
        case rows.showCast.rawValue: cell.setupCell(title: "Showcast:", body: movie.showCast)
        case rows.runtime.rawValue: cell.setupCell(title: "Runtime:", body: movie.runtime)
        default: break
        }
        
        return cell
    }
}

extension MovieDetailVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView == self.tableView) {
            
            self.setCellImageOffset(view: self.headerView)
        }
    }
    
    func setCellImageOffset(view: UIView) {
        
        let cellFrame = self.headerView.imgView.bounds
        let cellFrameInCollection = self.tableView.convert(cellFrame, to: self.tableView.superview)
        let cellOffset = cellFrameInCollection.origin.y + cellFrameInCollection.size.height
        let collectionViewHeight = self.tableView.bounds.size.height + cellFrameInCollection.size.height
        let cellOffsetFactor = cellOffset / collectionViewHeight
        self.headerView.setImageOffset(offset: cellOffsetFactor)
    }
}
