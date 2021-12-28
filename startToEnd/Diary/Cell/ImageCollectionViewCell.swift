//
//  ImageCollectionViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/09.
//

import UIKit


/// 첨부한 이미지를 디테일 화면에 표시하는 컬렉션 뷰 셀
class ImageCollectionViewCell: UICollectionViewCell {
    
    /// 첨부한 이미지 뷰
    @IBOutlet weak var attachedImageView: UIImageView!
    
    
    /// 셀을 초기화합니다
    /// - Parameter image: UIImage객체
    func configure(image: UIImage) {
        attachedImageView.image = image
    }
}
