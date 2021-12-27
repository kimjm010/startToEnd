//
//  Model.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import Foundation
import UIKit

class PhotoGallery {
    init(image: Data) {
        self.image = image
    }
    
    var image: Data
}


//class MyDiary {
//    init(content: String? = nil,
//         insertDate: Date,
//         statusImage: UIImage? = nil,
//         images: UIImage? = nil) {
//        self.content = content
//        self.insertDate = insertDate
//        self.statusImage = statusImage
//        self.images = images
//    }
//
//    var content: String?
//    var insertDate: Date
//    var statusImage: UIImage?
//    var images: UIImage?
//}

