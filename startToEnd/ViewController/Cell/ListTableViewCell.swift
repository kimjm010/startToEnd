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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        toggleCompleteButton.setTitle("", for: .normal)
        markHighlightButton.setTitle("", for: .normal)
    }
    
    
    func configure(todo: Todo) {
        toDoLabel.text = todo.content
        categoryLabel.text = todo.toDoCategory.rawValue
        dateLabel.text = todo.insertDate.dateToString
    }
}
