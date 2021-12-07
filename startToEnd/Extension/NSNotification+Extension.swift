//
//  NSNotification+Extension.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/07.
//

import Foundation

extension NSNotification.Name {
    
    /// ToDoList를 업데이트할 때 Broadcast 하기 위한 Notification속성
    static let updateToDo = Notification.Name(rawValue: "updateToDo")
    
    /// 카테고리를 선택할 때 Broadcast 하기 위한 Notification속성
    static let selectCategory = Notification.Name(rawValue: "selectCategory")
    
    /// 카테고리를 추가할 때 Broadcast 하기 위한 Notification속성
    static let newCategoryDidInsert = Notification.Name(rawValue: "newCategoryDidInsert")
    
}
