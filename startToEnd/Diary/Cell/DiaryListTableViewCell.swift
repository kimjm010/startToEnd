//
//  DiaryListTableViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit

class DiaryListTableViewCell: UITableViewCell {

    /// 일기 내용
    @IBOutlet weak var contentLabel: UILabel!
    
    /// 일기 작성 일자
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 그날의 감정
    ///
    /// 일기 작성 시의 감정을 이미지로 표헌합니다.
    @IBOutlet weak var statusImageView: UIImageView!
    
    
    /// 셀을 초기화합니다.
    /// - Parameter diary: MyDiaryEntity 객체
    func configure(diary: MyDiaryEntity) {
        contentLabel.text = diary.content
        dateLabel.text = diary.insertDate?.dateToString
        statusImageView.image = UIImage(data: diary.statusImage ?? Data())
    }
}
