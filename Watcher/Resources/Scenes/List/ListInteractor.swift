//
//  ListInteractor.swift
//  Watcher
//
//  Created by Rj on 19/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

protocol ListInteractorInput {
    func fetchItems(request: ListModel.Fetch.Request)
}

protocol ListInteractorOutput {
    func presentFetchResults(response: ListModel.Fetch.Response)
}

class ListInteractor: ListInteractorInput {
    
    var output: ListInteractorInput!
    var worker: ListWorker!
    
    func fetchItems(request: ListModel.Fetch.Request) {
        
    }
    
}
