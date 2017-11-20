//
//  DataManager.swift
//  Watcher
//
//  Created by Rj on 20/11/2017.
//  Copyright © 2017 Rj. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    static let movieEntity = "Movie"
    
    class func core() -> (manageContext: NSManagedObjectContext, entity: NSEntityDescription) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: movieEntity, in: manageContext)
        
        return (manageContext, entity!)
    }
    
    class func add(movie: MovieDetail) {
        
        let model = NSManagedObject(entity: core().entity, insertInto: core().manageContext)
        model.setValue(movie.id, forKey: "id")
        model.setValue(movie.title, forKey: "title")
        model.setValue(movie.poster_path, forKey: "poster_path")
        model.setValue(movie.backdrop_path, forKey: "backdrop_path")
        model.setValue(movie.overview, forKey: "overview")
        model.setValue(movie.vote_average, forKey: "vote_average")
        model.setValue(movie.vote_count, forKey: "vote_count")
        model.setValue(movie.release_date, forKey: "release_date")
  
        do {
            try core().manageContext.save()
        } catch let error as NSError {
            print("something went wrong here: \(error.userInfo)")
        }
    }
    
    class func fetchData(id: Int = -1) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: movieEntity)
        
        if id != -1 {
            fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        }
        
        do {
            return try core().manageContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("something went wrong here: \(error.userInfo)")
        }
        
        return [NSManagedObject]()
    }
    
    class func deleteMovie(withId trackId: Int) {
        core().manageContext.delete(fetchData(id: trackId)[0] as NSManagedObject)
        do {
            try core().manageContext.save()
        } catch let error as NSError {
            print("something went wrong here: \(error.userInfo)")
        }
    }
    
    class func movieAlreadyExist(withID id: Int) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: movieEntity)
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try core().manageContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("something went wrong here: \(error.userInfo)")
        }
        
        return results.count != 0 ? true : false
    }
    
}
