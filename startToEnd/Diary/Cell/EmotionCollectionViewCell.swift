//
//  EmotionCollectionViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit

class EmotionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var emotiomImageView: UIImageView!
    
    
    /// 셀을 초기화합니다.
    /// - Parameter image: image객체
    func configure(image: UIImage) {
        emotiomImageView.image = image
    }
}
