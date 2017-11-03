

//
//  ListRouter.swift
//  Watcher
//
//  Created by Rj on 19/10/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit

protocol ListRouterInput {
    func showDetailVC()
}

class ListRouter: ListRouterInput {

    weak var listController: ListController!
    
    func showDetailVC() {
        listController.performSegue(withIdentifier: "detailsVC", sender: nil)
    }
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        
        if segue.identifier == "otherVC" {
            
        }
    }
    
}
