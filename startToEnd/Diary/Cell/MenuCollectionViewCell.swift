//
//  MenuCollectionViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/09.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageContainerView: UIView!
    
    override func awakeFromNib() {
        imageContainerView.applyBigRoundedRect()
    }
}
