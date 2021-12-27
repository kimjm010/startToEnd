//
//  SelectCategoryTableViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/03.
//

import UIKit


/// 카테고리 선택 화면 테이블 뷰 셀
class SelectCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    /// 카테고리 선택 화면 테이블 뷰 셀을 초기화합니다.
    /// - Parameter category: category 이름
    func configure(category: String) {
        categoryLabel.text = category
    }
}
