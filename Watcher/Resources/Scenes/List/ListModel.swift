//
//  ListModel.swift
//  Watcher
//
//  Created by Rj on 19/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

struct ListModel {
    
    struct Fetch {
        struct Request
        {
            var itemId = 0
//            var keyword: String?
//            var count: String?
        }
        struct Response
        {
            var object: MovieDetail?
            var isError: Bool?
            var message: String?
        }
        struct ViewModel
        {
            var id: Int?
            var title: String?
            var poster_path: String?
            var backdrop_path: String?
            var isError: Bool
            var message: String?
        }
    }
    
}
