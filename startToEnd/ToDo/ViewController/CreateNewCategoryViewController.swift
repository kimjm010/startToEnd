//
//  CreateNewCategoryViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/06.
//

import UIKit


class CreateNewCategoryViewController: UIViewController {
    
    @IBOutlet weak var composeNewCategoryTextField: UITextField!
    
    
    @IBAction func insertNewCategory(_ sender: Any) {
        guard let newCategory = composeNewCategoryTextField.text, newCategory.count > 0 else {
            alertNoText(title: "알림", message: "카테고리를 입력해주세요 :)", handler: nil)
            return
        }
        
        let userInfo = ["newCategory": newCategory]
        NotificationCenter.default.post(name: .newCategoryDidInsert, object: nil, userInfo: userInfo)
        navigationController?.popViewController(animated: true)
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        composeNewCategoryTextField.becomeFirstResponder()
    }
}
