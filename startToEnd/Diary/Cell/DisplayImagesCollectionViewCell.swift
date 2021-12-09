//
//  DisplayImagesCollectionViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/09.
//

import UIKit


class DisplayImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var dimmingView: UIView!
    
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    /// dimmingView의 alpha값을 조절합니다.
    private func showDimmingView() {
        let alpha: CGFloat = isSelected ? 0.3 : 0.0
        dimmingView.alpha = alpha
    }
    
    
    /// 셀을 초기화합니다.
    func configure(img: UIImage?) {
        photoImage.image = img
    }
    
    
    /// 셀의 선택 상태 및 alpha값을 리셋합니다.
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        showDimmingView()
    }
    
    
    /// 이미지 뷰 셀의 선택 상태 확인
    override var isSelected: Bool {
        didSet {
            showDimmingView()
            setNeedsLayout()
        }
    }
}
