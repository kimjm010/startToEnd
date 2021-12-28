//
//  Date+Formatter.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/02.
//

import Foundation

fileprivate let formatter = DateFormatter()

extension Date {
    
    /// todo, diary에 표시할 날짜 형식
    var dateToString: String {
        formatter.dateFormat = "YY.MM.dd"
        formatter.locale = Locale(identifier: "en_us")
        return formatter.string(from: self)
    }
}
