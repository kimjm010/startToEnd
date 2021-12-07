//
//  DetailViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/01.
//

import UIKit
import DropDown


class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTextViewPlaceholder: UILabel!
    
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    
    @IBOutlet weak var toggleIsMarkedButton: UIButton!

    @IBOutlet weak var contentTextField: UITextField!
    
    @IBOutlet weak var MarkedImageView: UIImageView!
    
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    /// todo 데이터 저장 속성
    var reallySelectedTodo: Todo1?
    
    /// category 배열
    var categoryList = Category2.allCases
    
    /// 선택된 toDoList의 카테고리 속성
    var selectedCategoryRawvalue: Category2?
    
    
    /// MarkImageView를 토글합니다.
    /// - Parameter sender: toggleIsMarkedButton
    @IBAction func toggleMark(_ sender: UIButton) {
        //guard let selectedTodo = selectedTodo else { return }
        guard let reallySelectedTodo = reallySelectedTodo else { return }


        if !(reallySelectedTodo.isMarked) {
            MarkedImageView.isHighlighted = true
            reallySelectedTodo.isMarked = true
        } else {
            MarkedImageView.isHighlighted = false
            reallySelectedTodo.isMarked = false
        }
    }
    
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func updateSelectedToDo(_ sender: Any) {
        
        //guard let selectedTodo = selectedTodo else { return }
        guard let reallySelectedTodo = reallySelectedTodo else { return }
        
        //let userInfo = ["updated": selectedTodo]
        let reallyUserInfo = ["updated": reallySelectedTodo]
        //NotificationCenter.default.post(name: .updateToDo, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(name: .updateToDo, object: nil, userInfo: reallyUserInfo)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func initializeData() {
        contentTextField.text = reallySelectedTodo?.content
        dateTimeLabel.text = reallySelectedTodo?.insertDate.dateToString
        detailTextView.isHidden = false
        toggleIsMarkedButton.setTitle("", for: .normal)
        
        guard let selectedCategoryRawvalue = selectedCategoryRawvalue else { return }
        categoryPickerView.selectRow(selectedCategoryRawvalue.rawValue, inComponent: 0, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            
            let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            let height = frame?.height
            
            guard let height = height else { return }
            
            var inset = self.detailTextView.contentInset
            inset.bottom = height
            self.detailTextView.contentInset = inset
            
            inset = self.detailTextView.verticalScrollIndicatorInsets
            inset.bottom = height
            self.detailTextView.verticalScrollIndicatorInsets = inset
        }
        
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            
            self.detailTextView.contentInset.bottom = 0
            self.detailTextView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
   
}




extension DetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        detailTextViewPlaceholder.isHidden = true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let content = textView.text, content.count > 0 else {
            detailTextViewPlaceholder.isHidden = false
            return
        }
        
        detailTextViewPlaceholder.isHidden = true
        print(content)
    }
}




extension DetailViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let content = textField.text, content.count > 0 else { return }
        
        reallySelectedTodo?.content = content
    }
}




extension DetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
}




extension DetailViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(categoryList[row])"
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reallySelectedTodo?.category.categoryName = categoryList[row]
    }
    
}
