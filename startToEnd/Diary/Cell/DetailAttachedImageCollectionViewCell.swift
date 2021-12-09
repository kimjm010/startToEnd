//
//  DetailAttachedImageCollectionViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/09.
//

import UIKit

class DetailAttachedImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var attachedImageView: UIImageView!
    
    
    func configure(img: UIImage?) {
        attachedImageView.image = img
    }
}
