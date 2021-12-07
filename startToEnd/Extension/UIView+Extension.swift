//
//  UIView+Extension.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/07.
//

import UIKit

extension UIView {
    
    /// 뷰에 적용할 스타일 옵션
    enum ViewStyleOptions {
        case lightShadow
        case pillShape
    }
    
    
    /// 대상 뷰에 스타일 옵션을 적용합니다.
    ///
    /// 배열에 저장된 순서대로 적용됩니다.
    /// - Parameter options: 스타일 옵션 배열
    func configureStyle(with options: [ViewStyleOptions]) {
        for option in options {
            switch option {
            case .lightShadow:
                self.applyLightShadow()
            case .pillShape:
                applyPillShape()
            }
        }
    }
    
    /// 뷰에 알약 모양을 적용합니다.
    func applyPillShape() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    /// 옅은 그림자를 추가합니다.
    func applyLightShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
    }

}
