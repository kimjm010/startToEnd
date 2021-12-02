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
    
    let content: String
    let toDoCategory: toDoCategory
    let isMarked: Bool
    let insertDate: Date
    
    enum toDoCategory: String {
        case duty = "업무"
        case workout = "운동"
        case study = "개인"
    }
}




struct Category {
    let dayCategory: String
}


let categoryList = [
    Category(dayCategory: "Today"),
    Category(dayCategory: "ThisWeek"),
    Category(dayCategory: "ThisMonth")
]


//
//var dummyTodayList = [
//    Todo(content: [
//    "개인 프로젝트 1일 1Commit",
//    "그룹 프로젝트 리뷰 확인 후 반영하기",
//    "12월부터 운동해서 체중 감량",
//    "중소기업 전세대출, 전세대출 등 알아볼 것",
//    ], timeZone: 0),
//
//    Todo(content: [
//    "개인 프로젝트 1일 1Commit235423521",
//    "그룹 프로젝트 리뷰 확인 후 반영하기5454353524",
//    "12월부터 운동해서 체중 감량ㅎㄹㅇㄴㅎㄹㅇㄴㅎㄹ",
//    "중소기업 전세대출, 전세대출 등 알아볼 것    asfgdsgdsaf",
//    ], timeZone: 1),
//]
//
//var dummyThisWeekList = [
//    Todo(content: [
//    "이번주: 개인 프로젝트 1일 1Commit",
//    "이번주: 그룹 프로젝트 리뷰 확인 후 반영하기",
//    "이번주: 12월부터 운동해서 체중 감량",
//    "이번주: 중소기업 전세대출, 전세대출 등 알아볼 것",
//    ], timeZone: 0),
//
//    Todo(content: [
//    "이번주: 개인 프로젝트 1일 1Commit235423521",
//    "이번주: 그룹 프로젝트 리뷰 확인 후 반영하기5454353524",
//    "이번주: 12월부터 운동해서 체중 감량ㅎㄹㅇㄴㅎㄹㅇㄴㅎㄹ",
//    "이번주: 중소기업 전세대출, 전세대출 등 알아볼 것    asfgdsgdsaf",
//    ], timeZone: 1),
//]
//
//
//var dummyThisMonthList = [
//    Todo(content: [
//    "이번달: 개인 프로젝트 1일 1Commit",
//    "이번달: 그룹 프로젝트 리뷰 확인 후 반영하기",
//    "이번달: 12월부터 운동해서 체중 감량",
//    "이번달: 중소기업 전세대출, 전세대출 등 알아볼 것",
//    ], timeZone: 0),
//
//    Todo(content: [
//    "이번달: 개인 프로젝트 1일 1Commit235423521",
//    "이번달: 그룹 프로젝트 리뷰 확인 후 반영하기5454353524",
//    "이번달: 12월부터 운동해서 체중 감량ㅎㄹㅇㄴㅎㄹㅇㄴㅎㄹ",
//    "이번달: 중소기업 전세대출, 전세대출 등 알아볼 것    asfgdsgdsaf",
//    ], timeZone: 1),
//]
//
//
//
//struct Category {
//    let category: String
//}
//
//
//
//var categoryList = [
//    Category(category: "Today"),
//    Category(category: "ThisWeek"),
//    Category(category: "ThisMonth")
//]
