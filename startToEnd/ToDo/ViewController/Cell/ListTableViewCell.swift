//
//  ListTableViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/11/30.
//

import UIKit


class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var toDoLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var toggleCompleteButton: UIButton!
    
    @IBOutlet weak var markHighlightButton: UIButton!
    
    @IBOutlet weak var isMarkedImageView: UIImageView!
    
    @IBOutlet weak var isCompletedImageView: UIImageView!
    
    var isCompleted: Bool = false
    
    var isMarked: Bool = false
    
    
    @IBAction func toggleMarked(_ sender: UIButton) {
        isMarked = isMarked ? false : true
        isMarkedImageView.isHighlighted = isMarked ? true : false
    }
    
    
    @IBAction func toggleComplete(_ sender: Any) {
        isCompleted = isCompleted ? false : true
        isCompletedImageView.isHighlighted = isCompleted ? true : false
        self.alpha = isCompleted ? 0.2 : 1.0
        // TODO: Haptic Touch 넣어보기!
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        toggleCompleteButton.setTitle("", for: .normal)
        markHighlightButton.setTitle("", for: .normal)
    }
    
    
    func reallyConfigure(todo1: Todo1) {
        toDoLabel.text = todo1.content
        dateLabel.text = todo1.insertDate.dateTimeToString
        categoryLabel.text = "\(todo1.category.categoryName)"
        isMarkedImageView.isHighlighted = isMarked
        isCompletedImageView.isHighlighted = isCompleted
    }
}
