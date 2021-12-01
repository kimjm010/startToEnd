//
//  CategoryCollectionViewCell.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/11/29.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    func configure(category: Category) {
        categoryLabel.text = category.category
    }
}
