//
//  DataManager.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/11.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    private init() { }
    
    /// todo리스트 배열
    var todoList = [TodoEntity]()
    
    /// myDiary리스트 배열
    var myDiaryList = [MyDiaryEntity]()

    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "startToEnd")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveMainContext() {
        mainContext.perform {
            if self.mainContext.hasChanges {
                do {
                    try self.mainContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
