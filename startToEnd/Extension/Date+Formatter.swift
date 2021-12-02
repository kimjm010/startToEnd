//
//  Date+Formatter.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/02.
//

import Foundation

fileprivate let formatter = DateFormatter()

extension Date {
    var dateToString: String {
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.locale = Locale(identifier: "ko_kr")
        return formatter.string(from: self)
    }
}
