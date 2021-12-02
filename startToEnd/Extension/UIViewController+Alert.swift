//
//  UIViewController+Alert.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/01.
//

import UIKit


extension  UIViewController {
    
    
    /// 입력된 toDoList가 없는 경우 알림 표시
    /// - Parameters:
    ///   - title:알림의 title
    ///   - message: 알림의 message
    ///   - handler: 알림 이후의 동작
    func alertNoText(title: String, message: String, handler: ((UIAlertAction) -> Void
    )? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
