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
    
    var selectedToDo: Todo?
    
    
    @IBAction func toggleMarked(_ sender: UIButton) {

        print(#function, selectedToDo?.content, selectedToDo?.isMarked)
        // TODO: toDo가 nil이야
        guard let selectedToDo = selectedToDo else { return }

        if !(selectedToDo.isMarked) {
            isMarkedImageView.isHighlighted = true
            selectedToDo.isMarked = true
        } else {
            selectedToDo.isMarked = false
            isMarkedImageView.isHighlighted = false
        }
        
        //isMarkedImageView.isHighlighted = selectedToDo.isMarked ? false : true
        //selectedToDo.isMarked = selectedToDo.isMarked ? false : true
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        toggleCompleteButton.setTitle("", for: .normal)
        markHighlightButton.setTitle("", for: .normal)
    }
    
    
    func configure(todo: Todo) {
        toDoLabel.text = todo.content
        categoryLabel.text = todo.toDoCategory.rawValue
        dateLabel.text = todo.insertDate.dateToString
        isMarkedImageView.isHighlighted = todo.isMarked
    }
}
