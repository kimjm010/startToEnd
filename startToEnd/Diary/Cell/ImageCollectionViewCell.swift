//
//  ImageCollectionViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/09.
//

import UIKit


class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var attachedImageView: UIImageView!
    
    
    /// 셀을 초기화합니다
    /// - Parameter image: UIImage객체
    func configure(image: UIImage) {
        attachedImageView.image = image
    }
}
