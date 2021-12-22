//
//  DataManager+Todo.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/13.
//

import Foundation
import CoreData
import ImageIO


extension DataManager {
    
    // create
    func createTodo(content: String? = nil,
                    category: String,
                    insertDate: Date = Date(),
                    notiDate: Date? = nil,
                    isMarked: Bool = false,
                    isCompleted: Bool = false,
                    reminder: Bool = false,
                    isRepeat: Bool = false,
                    memo: String? = nil,
                    completion: (() -> ())? = nil) {
        mainContext.perform {
            let newTodo = TodoEntity(context: self.mainContext)
            newTodo.content = content
            newTodo.category = category
            newTodo.insertDate = insertDate
            newTodo.notiDate = notiDate
            newTodo.isMarked = isMarked
            newTodo.isCompleted = isCompleted
            newTodo.reminder = reminder
            newTodo.isRepeat = isRepeat
            newTodo.memo = memo
            
            self.todoList.insert(newTodo, at: 0)
            
            self.saveMainContext()
            completion?()
        }
    }
    
    
    // fetch
    func fetchTodo() {
        
        mainContext.performAndWait {
            let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            let sortByDateAsc = NSSortDescriptor(key: "insertDate", ascending: false)
            request.sortDescriptors = [sortByDateAsc]
            
            do {
                todoList = try mainContext.fetch(request)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    // update
    func updateTodo(entity: TodoEntity,
                    content: String,
                    insertDate: Date,
                    notiDate: Date?,
                    isMarked: Bool,
                    reminder: Bool,
                    isRepeat: Bool,
                    memo: String,
                    completion: (() -> ())? = nil) {
        mainContext.perform {
            entity.content = content
            entity.insertDate = insertDate
            entity.notiDate = notiDate
            entity.isMarked = isMarked
            entity.reminder = reminder
            entity.isRepeat = isRepeat
            entity.memo = memo
            
            
            self.saveMainContext()
            completion?()
        }
    }
    
    //update isMarked
    func updateIsMarked(entity: TodoEntity,
                        ismarked: Bool,
                        completion: (() -> ())? = nil) {
        mainContext.perform {
            entity.isMarked = ismarked
            
            self.saveMainContext()
            completion?()
        }
    }
    
    //update isCompleted
    func updateIsCompleted(entity: TodoEntity,
                        isCompleted: Bool,
                        completion: (() -> ())? = nil) {
        mainContext.perform {
            entity.isCompleted = isCompleted
            
            self.saveMainContext()
            completion?()
        }
    }
    
    // Delete
    func deleteTodo(entity: TodoEntity) {
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveMainContext()
        }
    }
}
