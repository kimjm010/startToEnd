//
//  EmotionCollectionViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit


/// 감정 이미지를 표시하는 컬렉션 뷰 셀
class EmotionCollectionViewCell: UICollectionViewCell {
    
    /// 감정 이미지 뷰
    @IBOutlet weak var emotiomImageView: UIImageView!
    
    
    /// 셀을 초기화합니다.
    /// - Parameter image: image객체
    func configure(image: UIImage) {
        emotiomImageView.image = image
    }
}
