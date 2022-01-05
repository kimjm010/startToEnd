//
//  AttachedImageCollectionViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/09.
//

import UIKit


/// 첨부한 이미지를 일기 작성화면에 푯기하는 컬렉션 뷰 셀
class AttachedImageCollectionViewCell: UICollectionViewCell {
    
    /// 첨부한 이미지 뷰
    @IBOutlet weak var attachedImage: UIImageView!
    
    
    func configure(image: UIImage) {
        attachedImage.image = image
    }
}
