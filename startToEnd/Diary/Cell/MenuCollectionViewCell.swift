//
//  MenuCollectionViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/09.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageContainerView: UIView!
    
    /// 셀이 로드되면 UI를 초기화합니다.
    override func awakeFromNib() {
        imageContainerView.applyBigRoundedRect()
    }
}
