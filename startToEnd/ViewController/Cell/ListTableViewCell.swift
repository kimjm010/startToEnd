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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configure(todo: Todo) {
        toDoLabel.text = todo.content
        categoryLabel.text = todo.toDoCategory.rawValue
    }
}
