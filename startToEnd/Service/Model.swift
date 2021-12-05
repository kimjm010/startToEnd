//
//  Model.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/11/27.
//

import Foundation
import UIKit


class Todo {
    init(content: String, toDoCategory: Todo.toDoCategory, isMarked: Bool = false, insertDate: Date = Date()) {
        self.content = content
        self.toDoCategory = toDoCategory
        self.isMarked = isMarked
        self.insertDate = insertDate
    }
    
    var content: String
    var toDoCategory: toDoCategory
    var isMarked: Bool
    let insertDate: Date
    
    enum toDoCategory: String {
        case duty = "업무"
        case workout = "운동"
        case study = "개인"
    }
}





struct Category {
    let dayCategory: String
    
    enum dayOption: String {
        case Today
        case ThisWeek
        case ThisMonth
    }
}


let categoryList = [
    Category(dayCategory: Category.dayOption.Today.rawValue),
    Category(dayCategory: Category.dayOption.ThisWeek.rawValue),
    Category(dayCategory: Category.dayOption.ThisMonth.rawValue)
]
