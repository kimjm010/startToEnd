//
//  DisplayImagesCollectionViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/09.
//

import UIKit


/// 이미지 목록을 나타내는 컬렉션 뷰 셀
class DisplayImagesCollectionViewCell: UICollectionViewCell {
    
    /// 사용자가 허용한 이미지 뷰
    @IBOutlet weak var photoImage: UIImageView!
    
    /// 디밍 뷰
    ///
    /// 선택상태에 따라 다르게 표시합니다.
    @IBOutlet weak var dimmingView: UIView!
    
    /// 체크마크 이미지 뷰
    ///
    /// 선택상태를 나타냅니다.
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    
    /// dimmingView의 alpha값을 조절합니다.
    private func showDimmingView() {
        let alpha: CGFloat = isSelected ? 0.3 : 0.0
        dimmingView.alpha = alpha
    }
    
    
    /// 셀을 초기화합니다.
    /// - Parameter img: UIImage 객체
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
