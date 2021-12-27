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



struct TodoCategory {
    let categoryOptions: String
}



enum Category2: Int, CaseIterable {
    case duty = 0
    case workout = 1
    case study = 2
}
