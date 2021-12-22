//
//  NSNotification+Extension.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/07.
//

import Foundation

extension NSNotification.Name {
    
    // MARK: TODO
    
    /// ToDoList를 업데이트할 때 Broadcast 하기 위한 Notification속성
    static let updateToDo = Notification.Name(rawValue: "updateToDo")
    
    /// 새로운 Todo를 추가할 때 Broadcast 하기 위한 Notification속성
    static let didInsertNewTodo = Notification.Name(rawValue: "didInsertNewTodo")
    
    /// 날짜를 지정할 때 Broadcast 하기 위한 Notification속성
    static let setNewDate = Notification.Name(rawValue: "setNewDate")
    
    /// dueDate을 업데이트할 때 Broadcast 하기 위한 Notification속성
    static let updateDueDate = Notification.Name(rawValue: "updateDueDate")
    
    // MARK: MyDiary
    
    /// 카테고리를 선택할 때 Broadcast 하기 위한 Notification속성
    static let selectCategory = Notification.Name(rawValue: "selectCategory")
    
    /// 카테고리를 추가할 때 Broadcast 하기 위한 Notification속성
    static let newCategoryDidInsert = Notification.Name(rawValue: "newCategoryDidInsert")
    
    /// 선택한 이미지를 Broadcast 하기 위한 Notification속성
    static let imageDidSelect = Notification.Name(rawValue: "imageDidSelect")
}
