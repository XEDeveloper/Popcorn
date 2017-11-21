//
//  PersonDetail.swift
//  Watcher
//
//  Created by Rj on 21/11/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit
import SwiftyJSON

class PersonDetail: NSObject {

    var id: Int?
    var name: String?
    var photo: String?
    var gender: Bool?
    var birthday: String?
    var deathday: String?
    var place_of_birth: String?
    var character: String?
    var biography: String?
    var imdb_id: String?
    var homepage: String?
    
    init(id: Int, name: String, photo: String, gender: Bool, birthday: String, deathday: String, place_of_birth: String, character: String, biography: String, imdb_id: String, homepage: String) {
        
        self.id = id
        self.name = name
        self.photo = photo
        self.gender = gender
        self.birthday = birthday
        self.deathday = deathday
        self.place_of_birth = place_of_birth
        self.character = character
        self.biography = biography
        self.imdb_id = imdb_id
        self.homepage = homepage
    }
    
    init(json: JSON) {
        
        id = json["id"].int
        name = json["name"].stringValue
        photo = json["profile_path"].stringValue
        character = json["character"].stringValue
        gender = json["gender"].boolValue
        birthday = json["birthday"].stringValue
        deathday = json["deathday"].stringValue
        place_of_birth = json["place_of_birth"].stringValue
        character = json["character"].stringValue
        biography = json["biography"].stringValue
        imdb_id = json["imdb_id"].stringValue
        homepage = json["homepage"].stringValue
    }
    
}
