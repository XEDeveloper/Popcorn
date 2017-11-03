
//
//  ListWorker.swift
//  Watcher
//
//  Created by Rj on 19/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import SwiftyJSON

typealias responseHandler = (_ response: ListModel.Fetch.Response) -> ()

class ListWorker {

    func fetch(itemID: Int!, success: @escaping(responseHandler), fail: @escaping(responseHandler)) {
        
        let manager = APIManager()
        
//        manager.fetchMoviesWithPage(page: 1, onSuccess: { json in
//            print(json)
//            success(ListModel.Fetch.Response(object: json, isError: false, message: nil))
//        }, onFailure: { error in
//            print(error)
//            fail(ListModel.Fetch.Response(object: nil, isError: true, message: "list error"))
//        })
        
//        manager.fetch(itemId: itemID, success: { (data) in
//            let test = Test(JSON: data)
//            success()
//        }) { (error, message) in
//            fail
//        }
    }
    
}
