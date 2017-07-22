//
//  Movie.swift
//  SDDemo
//
//  Created by José Ferré on 21/7/17.
//  Copyright © 2017 José Ferré. All rights reserved.
//

import Foundation
import ObjectMapper

final class Movie: RealmBaseObject {

    dynamic var unit = 0
    dynamic var showID = 0
    dynamic var mediaType = 0
    
    dynamic var showTitle: String? = nil
    dynamic var releaseYear: String? = nil
    dynamic var rating: String? = nil
    dynamic var category: String? = nil
    dynamic var showCast: String? = nil
    dynamic var director: String? = nil
    dynamic var summary: String? = nil
    dynamic var posterURL: String? = nil
    dynamic var runtime: String? = nil
    
    dynamic var favorited = false
    
    required convenience init?(map: Map) { self.init() }
    
    override class func primaryKey() -> String? {
        return "showID"
    }
    
    override func mapping(map: Map) {
        unit            <- map["unit"]
        showID          <- map["show_id"]
        mediaType       <- map["mediatype"]
        showTitle       <- map["show_title"]
        releaseYear     <- map["release_year"]
        rating          <- map["rating"]
        category        <- map["category"]
        showCast        <- map["show_cast"]
        director        <- map["director"]
        summary         <- map["summary"]
        posterURL       <- map["poster"]
        runtime         <- map["runtime"]
    }
}
