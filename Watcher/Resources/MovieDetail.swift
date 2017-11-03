//
//  MovieDetail.swift
//  Watcher
//
//  Created by Rj on 23/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit
import SwiftyJSON

struct MovieDetail {
    
    var id: Int?
    var title: String?
    var poster_path: String?
    var backdrop_path: String?
    var overview: String?
    var vote_average: Double?
    var vote_count: Int?
    var release_date: String?
    
    var isError: Bool
    var message: String?
    
    init(id: Int, title: String, poster_path: String, backdrop_path: String, overview: String, vote_average: Double, vote_count: Int, release_date: String, isError: Bool, message: String) {
        
        self.id = id
        self.title = title
        self.poster_path = poster_path
        self.backdrop_path = backdrop_path
        self.overview = overview
        self.vote_average = vote_average
        self.vote_count = vote_count
        self.release_date = release_date
        self.isError = isError
        self.message = message
    }
    
    init(json: JSON) {
        id = json["id"] .int
        title = json["title"].stringValue
        if title == "" {
            title = json["name"].stringValue
        }
        poster_path = json["poster_path"].stringValue
        backdrop_path = json["backdrop_path"].stringValue
        overview = json["overview"].stringValue
        vote_average = json["vote_average"].double
        vote_count = json["vote_count"].int
        release_date = json["release_date"].stringValue
        if release_date == "" {
            release_date = json["first_air_date"].stringValue
        }
        isError = false
        message = "success"
    }
    
}
