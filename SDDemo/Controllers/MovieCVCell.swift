//
//  MovieCVCell.swift
//  SDDemo
//
//  Created by José Ferré on 21/7/17.
//  Copyright © 2017 José Ferré. All rights reserved.
//

import UIKit
import AlamofireImage
import RealmSwift
import ChameleonFramework

protocol MovieCellDelegate: class {
    
    func btnFavPressed(cell: MovieCVCell)
}

class MovieCVCell: UICollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    
    static let REUSE_ID = "movieCellReuseID"
    weak var delegate: MovieCellDelegate? = nil
    var isHeightCalculated: Bool = false
    
    func setupCell(withMovie movie: Movie, delegate: MovieCellDelegate?) {
        
        self.delegate = delegate
        loadPoster(movie: movie)
        lblTitle.text = movie.showTitle
        initCosmetics(movie: movie)
    }
    
    func loadPoster(movie: Movie) {
        
        if movie.posterURL != nil, let imgUrl = URL.init(string: movie.posterURL!) {
            
            imgPoster.af_setImage(withURL: imgUrl, placeholderImage: nil, imageTransition: UIImageView.ImageTransition.crossDissolve(0.4), runImageTransitionIfCached: false, completion: { image in
            
                self.lblPlaceHolder.isHidden = image.error == nil
            })
        }
    }
    
    private func initCosmetics(movie: Movie) {
        
        if (try! Realm().object(ofType: Movie.self, forPrimaryKey: movie.showID)) != nil {
            btnFavorite.setImage(#imageLiteral(resourceName: "ic_favorite"), for: .normal)
            btnFavorite.tintColor = .flatWatermelon
        } else {
            btnFavorite.setImage(#imageLiteral(resourceName: "ic_favorite_border"), for: .normal)
            btnFavorite.tintColor = UIColor.flatGray
        }
        
        btnFavorite.backgroundColor = .white
        btnFavorite.layer.cornerRadius = btnFavorite.bounds.width * 0.5
        btnFavorite.clipsToBounds = true
        
        lblTitle.textColor = UIColor.flatBlack.lighten(byPercentage: 0.20)
        lblPlaceHolder.textColor = UIColor.flatBlack.lighten(byPercentage: 0.20)
        
        viewContainer.backgroundColor = .flatWhite
        
        applyShadow()
    }
    
    private func applyShadow() {
        
        self.viewContainer.layer.cornerRadius = 3.0
        self.viewContainer.layer.rasterizationScale = UIScreen.main.scale
        self.viewContainer.layer.masksToBounds = true
        self.viewContainer.clipsToBounds = true
        
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.shadowColor = UIColor.flatBlack.cgColor
        self.contentView.layer.shadowOpacity = 0.2
        self.contentView.layer.shadowRadius = 1.5
        self.contentView.layer.shadowOffset = CGSize.init(width: 1.0, height: 2.0)
        self.contentView.layer.shouldRasterize = true
        self.contentView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    @IBAction func btnFavPressed(_ sender: Any) {
        
        delegate?.btnFavPressed(cell: self)
    }
    
    override func prepareForReuse() {
        imgPoster.af_cancelImageRequest()
        imgPoster.image = nil
        lblTitle.text = nil
        delegate = nil
        btnFavorite.imageView?.image = nil
        self.lblPlaceHolder.isHidden = false
    }
}
