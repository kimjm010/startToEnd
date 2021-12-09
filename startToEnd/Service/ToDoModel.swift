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




class Todo1 {
    init(content: String, insertDate: Date = Date(), category: Category1, isMarked: Bool = false, isCompleted: Bool = false) {
        self.content = content
        self.insertDate = insertDate
        self.category = category
        self.isMarked = isMarked
        self.isCompleted = isCompleted
    }
    
    var content: String
    let insertDate: Date
    var category: Category1
    var isMarked: Bool
    var isCompleted: Bool
}




enum Category2: Int, CaseIterable {
    case duty = 0
    case workout = 1
    case study = 2
}




class Category1 {
    var categoryName: Category2
    
    init(categoryName: Category2) {
        self.categoryName = categoryName
    }
}

// MARK: 더미데이터
var dummyToDoList = [
    Todo1(content: "1번째 할 일 입니다.",
          insertDate: Date(),
          category: Category1(categoryName: Category2.duty),
          isMarked: false,
          isCompleted: false),
    
    Todo1(content: "2번째 할 일 입니다.",
          insertDate: Date().addingTimeInterval(200),
          category: Category1(categoryName: Category2.workout),
          isMarked: false,
          isCompleted: false),
    
    Todo1(content: "3번째 할 일 입니다.",
          insertDate: Date().addingTimeInterval(300),
          category: Category1(categoryName: Category2.workout),
          isMarked: false,
          isCompleted: false),
    
    Todo1(content: "4번째 할 일 입니다.",
          insertDate: Date().addingTimeInterval(500),
          category: Category1(categoryName: Category2.workout),
          isMarked: false,
          isCompleted: false),
    
    Todo1(content: "5번째 할 일 입니다.",
          insertDate: Date().addingTimeInterval(600),
          category: Category1(categoryName: Category2.duty),
          isMarked: false,
          isCompleted: false),
    
    Todo1(content: "6번째 할 일 입니다.",
          insertDate: Date().addingTimeInterval(900),
          category: Category1(categoryName: Category2.study),
          isMarked: false,
          isCompleted: false),
    
    Todo1(content: "7번째 할 일 입니다.",
          insertDate: Date().addingTimeInterval(1200),
          category: Category1(categoryName: Category2.study),
          isMarked: false,
          isCompleted: false),
    
    Todo1(content: "8번째 할 일 입니다.",
          insertDate: Date().addingTimeInterval(2200),
          category: Category1(categoryName: Category2.workout),
          isMarked: false,
          isCompleted: false),
    
    Todo1(content: "9번째 할 일 입니다.",
          insertDate: Date().addingTimeInterval(3200),
          category: Category1(categoryName: Category2.duty),
          isMarked: false,
          isCompleted: false),
]
