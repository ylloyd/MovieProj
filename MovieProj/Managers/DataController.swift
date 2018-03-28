//
//  DataController.swift
//  MovieProj
//
//  Created by Yvan Elessa on 14/03/2018.
//  Copyright © 2018 Yvan Elessa. All rights reserved.
//

import Foundation
import CoreData

struct DataController {
    
    static let `default` = DataController()
    
    private var managedObjectContext: NSManagedObjectContext
    
    private init() {
        
        
        guard let modelURL = Bundle.main.url(forResource: "MovieProj", withExtension: "momd") else {
            fatalError("ha ha ha")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("hi hi hi")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = urls[urls.endIndex - 1]
        let storeUrl = docUrl.appendingPathComponent("Model.sqlite")
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
        } catch {
            fatalError("hu hu hu")
        }
    }
    
    func movies() -> [Movie] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        
//        let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        let nbProductsDescriptor = NSSortDescriptor(key: "numberOfProducts", ascending: true)
//        
//        request.sortDescriptors = [nbProductsDescriptor, nameDescriptor]
        
        do {
            guard let movies = try managedObjectContext.fetch(request) as? [Movie] else {
                return []
            }
            
            return movies
        } catch {
            return []
        }
    }
    
    func newObject(_ className: String) -> AnyObject {
        return NSEntityDescription.insertNewObject(forEntityName: className, into: managedObjectContext)
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("oups: cannot save")
        }
    }
    
}
