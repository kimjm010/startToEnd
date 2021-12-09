//
//  SelectCategoryTableViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/03.
//

import UIKit


class SelectCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    func configure(category: Category2) {
        categoryLabel.text = "\(category)"
    }
}
