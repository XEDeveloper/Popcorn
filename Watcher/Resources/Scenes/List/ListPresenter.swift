//
//  ListPresenter.swift
//  Watcher
//
//  Created by Rj on 19/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

protocol ListPresenterInput
{
    func presentFetchResults(response: ListModel.Fetch.Response)
}

protocol ListPresenterOutput: class
{
    func successFetchedItems(viewModel: ListModel.Fetch.ViewModel)
    func errorFetchingItems(viewModel: ListModel.Fetch.ViewModel)
}

class ListPresenter: ListPresenterInput {

    weak var output: ListPresenterOutput!
    
    func presentFetchResults(response: ListModel.Fetch.Response) {
        let viewModel = ListModel.Fetch.ViewModel(id: response.object?.id, title: response.object?.title, poster_path: response.object?.poster_path, backdrop_path: response.object?.backdrop_path, isError: (response.object?.isError)!, message: response.object?.message)
        
        if viewModel.isError {
            if let output = self.output {
                output.errorFetchingItems(viewModel: viewModel)
            }
        } else {
            if let output = self.output {
                output.successFetchedItems(viewModel: viewModel)
            }
        }
        
    }
}
