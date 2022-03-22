//
//  CreateNewCategoryViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/06.
//

import UIKit


/// 카테고리 추가 화면
class CreateNewCategoryViewController: UIViewController {
    
    /// category 텍스트 필드
    @IBOutlet weak var composeNewCategoryTextField: UITextField!
    
    
    /// 새로운 카테고리를 추가합니다.
    /// - Parameter category: 추가할 카테고리 이름
    private func createNewCategory(category: String) {
        DataManager.shared.createCategory(category: category) {
            NotificationCenter.default.post(name: .newCategoryDidInsert, object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// 새로운 카테고리를 추가합니다.
    /// - Parameter sender: save버튼
    @IBAction func insertNewCategory(_ sender: Any) {
        
        guard let newCategory = composeNewCategoryTextField.text, newCategory.count > 0 else {
            alertNoText(title: "알림", message: "카테고리를 입력해주세요 :)", handler: nil)
            return
        }
        
        createNewCategory(category: newCategory)
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        composeNewCategoryTextField.becomeFirstResponder()
    }
}




extension CreateNewCategoryViewController: UITextFieldDelegate {
    
    /// Return버튼을 눌러 새로운 카테고리를 저장합니다.
    /// - Parameter textField: composeNewCategoryTextField
    /// - Returns: 작업 실행 여부를 결정하는 Bool 값
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.hasText {
            guard let newCategory = textField.text else { return false }
            createNewCategory(category: newCategory)
        }
        
        return true
    }
}
