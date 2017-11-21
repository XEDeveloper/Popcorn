//
//  APIManager.swift
//  Watcher
//
//  Created by Rj on 23/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import Alamofire
import SwiftyJSON

class APIManager {

    let apiKey = "0c6d1397d875dca81b8ebabbb1c26c88" // move to keychain
    let baseURL = "https://api.themoviedb.org/3"
    let baseURLImage = "https://image.tmdb.org/t/p/w500"
    static let sharedInstance = APIManager()
    static let getMovieEndpoint = "/movie"
    static let getTvEndpoint = "/tv"
    static let getSeriesEndpoint = "/discover\(getTvEndpoint)"
    static let getMoviesEndpoint = "/discover\(getMovieEndpoint)"
    static let getSearchEndpoint = "/search\(getMovieEndpoint)"
    let getVideosEndpoint = "/videos"
    let person = "/person"
    let languageUS = "&language=en-US"
    
    var sortDict = [
        ["name": "Popularity Descending", "value": "popularity.desc"],
        ["name": "Popularity Ascending", "value": "popularity.asc"],
        ["name": "Rating Descending", "value": "rating.desc"],
        ["name": "Rating Ascending", "value": "rating.asc"],
        ["name": "Release Date Descending", "value": "release_date.desc"],
        ["name": "Release Date Ascending", "value": "release_date.asc"],
        ["name": "Title (A-Z)", "value": "title.desc"],
        ["name": "Title (Z-A)", "value": "title.asc"]
    ]
    
    func searchMoviesWithText(keyword: String, page: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url = baseURL + APIManager.getSearchEndpoint + "?api_key=\(apiKey)&query=\(keyword)&page=\(page)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 200:
                        if let result = response.result.value {
                            onSuccess(JSON(result))
                        }
                    default:
                        print("default")
                    }
                }
        }
    }
    
    func getMovieVideos(id: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {

        let url = baseURL + APIManager.getMovieEndpoint + "/\(id)" + getVideosEndpoint + "?api_key=\(apiKey)\(languageUS)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 200:
                        if let result = response.result.value {
                            onSuccess(JSON(result))
                        }
                    default:
                        print("request failed")
                    }
                }
        }
    }
    
    func fetchShows(withPage page: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        var url = baseURL + (Default.isSeries() ? APIManager.getSeriesEndpoint : APIManager.getMoviesEndpoint) + "?api_key=\(apiKey)\(languageUS)&sort_by=\(sortBy())&include_video=\(false)&page=\(page)&"
        
        url = url + (Default.isSeries() ? "timezone=\("America%2FNew_York")&include_null_first_air_dates=\(false)" // series
            : "include_adult=\(adult())&year=\(year())&") // movies
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 200:
                        if let result = response.result.value {
                            onSuccess(JSON(result))
                        }
                    default:
                        print("default fetchShows")
                        print(response)
                    }
                }
        }
    }

    func getShowDetails(id: Int, details: String, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url = baseURL + (Default.isSeries() ? APIManager.getTvEndpoint : APIManager.getMovieEndpoint) + "/\(id)" + "?api_key=\(apiKey)\(languageUS)&append_to_response=\(details)"
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 200:
                        if let result = response.result.value {
                            onSuccess(JSON(result))
                        }
                    default:
                        print("request failed")
                    }
                }
        }
    }
    
    func getPersonDetails(id: Int, shows: Bool = false, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void) {
        
        let url = baseURL + person + "/\(id)" + "\(shows ? "/movie_credits" : "")" + "?api_key=\(apiKey)\(languageUS)"
        print(url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 200:
                        if let result = response.result.value {
                            onSuccess(JSON(result))
                        }
                    default:
                        print("request failed")
                    }
                }
        }
    }
}

extension APIManager {

    func year() -> String {
        return Default.year() == "None" ? "" : Default.year()
    }
    
    func adult() -> Bool {
        return Default.adult() == "No" ? false : true
    }
    
    func sortBy() -> String {
        
        for item in sortDict {
            let itemDict = item as NSDictionary
            if itemDict["name"] as! String == Default.sortBy() {
                return itemDict["value"] as! String
            }
        }
        return ""
    }
}
