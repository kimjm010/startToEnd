//
//  Model.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/11/27.
//

import Foundation
import UIKit


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


class Todo {
    init(content: String? = nil,
         category: TodoCategory,
         insertDate: Date,
         notiDate: Date? = nil,
         isMarked: Bool = false,
         isCompleted: Bool = false,
         reminder: Bool = false,
         isRepeat: Bool = false,
         memo: String? = nil) {
        self.content = content
        self.category = category
        self.insertDate = insertDate
        self.notiDate = notiDate
        self.isMarked = isMarked
        self.isCompleted = isCompleted
        self.reminder = reminder
        self.isRepeat = isRepeat
        self.memo = memo
    }
    
    
    var content: String?
    var category: TodoCategory
    var insertDate: Date
    var notiDate: Date?
    var isMarked: Bool
    var isCompleted: Bool
    var reminder: Bool
    var isRepeat: Bool
    var memo: String?
}


struct TodoCategory {
    let categoryOptions: String
}





enum Category2: Int, CaseIterable {
    case duty = 0
    case workout = 1
    case study = 2
}


class Category1 {
    init(categoryName: Category2) {
        self.categoryName = categoryName
    }
    
    var categoryName: Category2
}
