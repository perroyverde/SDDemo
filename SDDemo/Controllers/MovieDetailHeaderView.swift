//
//  MovieDetailHeaderView.swift
//  SDDemo
//
//  Created by Jose Ferre on 22/7/17.
//  Copyright © 2017 José Ferré. All rights reserved.
//

import UIKit

class MovieDetailHeaderView: UIView {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTile: UILabel!
    @IBOutlet var viewGradient: UIView!
    @IBOutlet var constrBottomAnchor: NSLayoutConstraint!
    @IBOutlet var constrTopAnchor: NSLayoutConstraint!
    
    let PARALLAX_FACTOR: CGFloat = 60
    var imgBackTopInitial: CGFloat!
    var imgBackBottomInitial: CGFloat!

    func setupView(img: UIImage?, tittle: String) {

        imgView.image = img
        lblTile.text = tittle
        lblTile.textColor = UIColor.flatWhite
        
        imgView.clipsToBounds = true
        self.clipsToBounds = true
        self.constrBottomAnchor.constant -= 2 * PARALLAX_FACTOR
        self.imgBackTopInitial = self.constrTopAnchor.constant
        self.imgBackBottomInitial = self.constrBottomAnchor.constant
    }
    
    func setImageOffset(offset: CGFloat) {
        
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1 - boundOffset) * 2 * PARALLAX_FACTOR
        
        self.constrTopAnchor.constant = self.imgBackTopInitial - pixelOffset + 80
        self.constrBottomAnchor.constant = self.imgBackBottomInitial + pixelOffset - 80
    }
}
