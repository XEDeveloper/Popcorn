//
//  ListConfigurator.swift
//  Watcher
//
//  Created by Rj on 19/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

extension ListController: ListPresenterOutput
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension ListInteractor: ListControllerOutput
{
    
}

extension ListPresenter: ListInteractorOutput {
    
}

class ListConfigurator {

    static let sharedInstance = ListConfigurator()
    
    private init() {}
    
    func configure(viewController: ListController) {
        let router = ListRouter()
        router.listController = viewController
        
        let presenter = ListPresenter()
        presenter.output = viewController
        
//        let interactor = ListInteractor()
//        interactor.output = presenter as! ListInteractorInput
//
//        viewController.output = interactor
        viewController.router = router
    }
}
