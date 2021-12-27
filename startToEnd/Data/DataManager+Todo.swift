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
    
    /// Todo를 추가합니다.
    /// - Parameters:
    ///   - content: todo 내용
    ///   - category: todo 카테고리
    ///   - insertDate: todo 입력 날짜
    ///   - notiDate: 알림 날짜
    ///   - isMarked: 하이라이트 표시 여부
    ///   - isCompleted: 완료 표시 여부
    ///   - reminder: 알림 표시 여부
    ///   - isRepeat: 반복 알림 표시 여부
    ///   - memo: 메모 내용
    ///   - completion: 생성 후 실행할 작업
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
    
    
    /// Todo Category를 추가합니다.
    /// - Parameters:
    ///   - category: 추가할 카테고리 이름
    ///   - completion: 추가 후 실행할 작업
    func createCategory(category: String, completion: (() -> ())? = nil) {
        mainContext.perform {
            let newCategory = TodoCategoryEntity(context: self.mainContext)
            newCategory.category = category
            
            self.categoryList.insert(newCategory, at: 0)
            
            self.saveMainContext()
            completion?()
        }
    }
    
    
    /// Todo를 읽어옵니다.
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
    
    
    /// Todo를 업데이트 합니다.
    /// - Parameters:
    ///   - entity: TodoEntity
    ///   - content: 업데이트 내용
    ///   - insertDate: 업데이트 날짜
    ///   - notiDate: 업데이트할 알림 날짜
    ///   - isMarked: 하이라이트 업데이트 여부
    ///   - reminder: 알림 업데이트 여부
    ///   - isRepeat: 반복 알림 업데이트 여부
    ///   - memo: 메모 업데이트 여부
    ///   - completion: 업데이트 후 실행할 작업
    func updateTodo(entity: TodoEntity,
                    content: String? = nil,
                    insertDate: Date? = Date(),
                    notiDate: Date? = nil,
                    isMarked: Bool? = false,
                    reminder: Bool? = false,
                    isRepeat: Bool? = false,
                    memo: String? = nil,
                    completion: (() -> ())? = nil) {
        mainContext.perform {
            entity.content = content
            entity.insertDate = insertDate
            entity.notiDate = notiDate
            
            guard let isMarked = isMarked,
                  let isRepeat = isRepeat,
                  let reminder = reminder else { return }

            entity.isMarked = isMarked
            entity.reminder = reminder
            entity.isRepeat = isRepeat
            entity.memo = memo
            
            
            self.saveMainContext()
            completion?()
        }
    }
    
    
    /// Todo의 하이라이트를 업데이트 합니다.
    /// - Parameters:
    ///   - entity: TodoEntity
    ///   - ismarked: 하이라이트 여부
    ///   - completion: 업데이트 후 실행할 작업
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
