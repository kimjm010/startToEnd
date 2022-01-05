//
//  DiaryListTableViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit
import CoreData


/// 일기 목록을 표시하는 테이블 뷰 셀
class DiaryListTableViewCell: UITableViewCell {
    
    /// 일기 내용
    @IBOutlet weak var contentLabel: UILabel!
    
    /// 일기 작성 일자
    @IBOutlet weak var dateLabel: UILabel!
    
    
    /// 셀을 초기화합니다.
    /// - Parameter diary: MyDiaryEntity 객체
    func configure(diary: MyDiaryEntity) {
        contentLabel.text = diary.content
        dateLabel.text = diary.insertDate?.dateToString
    }
}
