//
//  UIViewController+Alert.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/01.
//

import UIKit


extension  UIViewController {
    func alertNoText(title: String, message: String, handler: ((UIAlertAction) -> Void
    )? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
