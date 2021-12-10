//
//  Model.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import Foundation
import UIKit
import CoreLocation


class MyDiary {
    init(content: String? = nil, insertDate: Date, statusImage: UIImage? = nil, images: [UIImage]? = nil) {
        self.content = content
        self.insertDate = insertDate
        self.statusImage = statusImage
        self.images = images
        //self.specificLocation = specificLocation
    }
    
    var content: String?
    var insertDate: Date
    var statusImage: UIImage?
    var images: [UIImage]?
    //var specificLocation: CLLocation
}


var dummyDiaryList = [
    MyDiary(content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.",
            insertDate: Date(),
            statusImage: UIImage(named: "1")),
    
    MyDiary(content: "꿈을 잃지 않기를 저 하늘 속에 속삭일래11",
            insertDate: Date(),
            statusImage: UIImage(named: "21")),
    
    MyDiary(content: "22꿈을 잃지 않기를 저 하늘 속에 속삭일래22",
            insertDate: Date().addingTimeInterval(-100053000),
            statusImage: UIImage(named: "38")),
    MyDiary(content: "66꿈을 잃지 않기를 저 하늘 속에 속삭일래33",
            insertDate: Date().addingTimeInterval(-1230000),
            statusImage: UIImage(named: "44")),
    MyDiary(content: "88꿈을 잃지 않기를 저 하늘 속에 속삭일래44",
            insertDate: Date().addingTimeInterval(-15332000),
            statusImage: UIImage(named: "50")),
    MyDiary(content: "55꿈을 잃지 않기를 저 하늘 속에 속삭일래33434",
            insertDate: Date().addingTimeInterval(-90053423),
            statusImage: UIImage(named: "28")),
    MyDiary(content: "374289꿈을 잃지 않기를 저 하늘 속에 속삭일래ㄴㅇㅁㄹㄴㅇ",
            insertDate: Date().addingTimeInterval(-100534000),
            statusImage: UIImage(named: "29")),
    MyDiary(content: "543532534꿈을 잃지 않기를 저 하늘 속에 속삭일래523543534",
            insertDate: Date().addingTimeInterval(-1000000),
            statusImage: UIImage(named: "60")),
]
