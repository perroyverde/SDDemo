//
//  MovieDetailCell.swift
//  SDDemo
//
//  Created by Jose Ferre on 22/7/17.
//  Copyright © 2017 José Ferré. All rights reserved.
//

import UIKit

class MovieDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    
    static let REUSE_ID = "detailCellReuseID"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(title: String, body: String?) {
        
        lblTitle.text = title
        lblTitle.textColor = UIColor.flatBlack.lighten(byPercentage: 0.20)
        lblBody.text = body
        lblBody.textColor = .flatGrayDark
        contentView.backgroundColor = .flatWhite
    }
    
    override func prepareForReuse() {
        
        lblTitle.text = nil
        lblBody.text = nil
    }
}
