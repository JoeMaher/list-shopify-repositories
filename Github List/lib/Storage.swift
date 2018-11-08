//
//  Storage.swift
//  Github List
//
//  Created by Joe Maher on 8/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Storage {

    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func getRepositories() -> Result<[Repository]> {
        return managedObjects()
            .flatMap { objects in traverse(objects, Repository.from) }
    }

    func managedObjects() -> Result<[NSManagedObject]> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.repository.rawValue)
        request.returnsObjectsAsFaults = false
        return .wrap {
            try context.fetch(request) as! [NSManagedObject]
        }
    }

    func storeRepositories(_ repos: [Repository]) -> Result<[()]> {
        return traverse(repos, storeRepository)
    }

    func storeRepository(_ repo: Repository) -> Result<()> {
        return .wrap {
            let entity = NSEntityDescription.entity(forEntityName: Entity.repository.rawValue, in: context)
            let newRepo = NSManagedObject(entity: entity!, insertInto: context)
            newRepo.setValue(repo.id, forKey: .id)
            newRepo.setValue(repo.name, forKey: .name)
            newRepo.setValue(repo.fork, forKey: .fork)
            newRepo.setValue(repo.stars, forKey: .stars)
            newRepo.setValue(repo.created, forKey: .created)
            newRepo.setValue(repo.url.absoluteString, forKey: .url)
            try context.save()
        }
    }

}

extension NSManagedObject {

    func setValue(_ value: Any, forKey key: RepositoryEntityKey) {
        self.setValue(value, forKey: key.rawValue)
    }

    func value(forKey key: RepositoryEntityKey) -> Any? {
        return self.value(forKey: key.rawValue)
    }
}
