//
//  ListTableViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/11/30.
//

import UIKit
import CoreData


/// 일기장 리스트 테이블 뷰 셀
class ListTableViewCell: UITableViewCell {

    /// todo레이블
    @IBOutlet weak var toDoLabel: UILabel!
    
    /// 카테고리 레이블
    @IBOutlet weak var categoryLabel: UILabel!
    
    /// 날짜 레이블
    @IBOutlet weak var dateLabel: UILabel!

    /// 완료 버튼
    @IBOutlet weak var toggleCompleteButton: UIButton!
    
    /// 하이라이트 버튼
    @IBOutlet weak var markHighlightButton: UIButton!
    
    /// 하이라이트 이미지 뷰
    ///
    /// 하이라이트 표시된 항목에 highlighted 이미지를 표시합니다.
    @IBOutlet weak var isMarkedImageView: UIImageView!
    
    /// 완료 이미지 뷰
    ///
    /// 완료 표시된 항목에 highlighted 이미지를 표시합니다.
    @IBOutlet weak var isCompletedImageView: UIImageView!
    
    /// 완료 여부 저장 속성
    var isCompleted: Bool = false
    
    /// 하이라이트 여부 저장 속성
    var isMarked: Bool = false
    
    /// updated여부
    var updated: Bool = false
    
    /// 선택된 Todo객체
    var selectedTodo: TodoEntity?
    
    /// 옵저버 제거를 위해 토큰을 담는 배열
    var tokens = [NSObjectProtocol]()
    
    
    /// 하이라이트 표시를 토글합니다.
    ///
    /// - Parameter sender: Mark Highlight 버튼
    @IBAction func toggleMarked(_ sender: Any) {
        isMarked = isMarked ? false : true
        isMarkedImageView.isHighlighted = isMarked ? true : false
    }
    
    
    /// 완료항목을 토글합니다.
    ///
    /// - Parameter sender: Toggle Complete 버튼
    @IBAction func toggleComplete(_ sender: Any) {
        isCompleted = isCompleted ? false : true
        isCompletedImageView.isHighlighted = isCompleted ? true : false
        self.alpha = isCompleted ? 0.2 : 1.0
        // TODO: Haptic Touch 넣어보기!
    }
    
    
    /// 셀이 로드되면 UI를 초기화합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        toggleCompleteButton.setTitle("", for: .normal)
        markHighlightButton.setTitle("", for: .normal)
    }
    
    
    /// 일기장 리스트 테이블 뷰 셀을 초기화합니다.
    /// - Parameter todo: todoEntity객체
    func configure(todo: TodoEntity) {
        toDoLabel.text = todo.content
        dateLabel.text = todo.insertDate?.dateToString
        categoryLabel.text = todo.category
        isMarkedImageView.isHighlighted = isMarked
        isCompletedImageView.isHighlighted = isCompleted
    }
}
