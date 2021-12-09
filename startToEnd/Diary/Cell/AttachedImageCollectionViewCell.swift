//
//  AttachedImageCollectionViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/09.
//

import UIKit

class AttachedImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var attachedImage: UIImageView!
    
    func configure(img: UIImage) {
        attachedImage.image = img
    }
}
