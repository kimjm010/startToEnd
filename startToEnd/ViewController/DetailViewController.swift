//
//  DetailViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/01.
//

import UIKit
import DropDown


extension NSNotification.Name {
    static let updateToDo = Notification.Name(rawValue: "updateToDo")
}

class DetailViewController: UIViewController {

    @IBOutlet weak var contentTextField: UITextField!
    
    @IBOutlet weak var MarkedImageView: UIImageView!
    
    @IBOutlet weak var changeCategoryButton: UIButton!
    
    @IBOutlet weak var toDoCategoryLabel: UILabel!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var detailTextViewPlaceholder: UILabel!
    
    @IBOutlet weak var toggleIsMarkedButton: UIButton!
    
    /// todo 데이터 저장 속성
    var selectedTodo: Todo?
    
    /// todoCategory 저장 속성
    var toDoCategory: Todo.toDoCategory?
    
    /// DropDown메뉴 표시 속성
    lazy var menu: DropDown? = {
       let menu = DropDown()
        menu.dataSource = [
            Todo.toDoCategory.duty.rawValue,
            Todo.toDoCategory.study.rawValue,
            Todo.toDoCategory.workout.rawValue
        ]
        return menu
    }()
    
    
    /// MarkImageView를 토글합니다.
    /// - Parameter sender: toggleIsMarkedButton
    @IBAction func toggleMark(_ sender: UIButton) {
        guard let selectedTodo = selectedTodo else { return }

        
        if !(selectedTodo.isMarked) {
            MarkedImageView.isHighlighted = true
            selectedTodo.isMarked = true
        } else {
            MarkedImageView.isHighlighted = false
            selectedTodo.isMarked = false
        }
    }
    
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func updateSelectedToDo(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        guard let selectedTodo = selectedTodo else { return }
        
        let userInfo = ["updated": selectedTodo]
        NotificationCenter.default.post(name: .updateToDo, object: nil, userInfo: userInfo)
    }
    
    
    /// 카테고리를 변경합니다.
    /// - Parameter sender: category 변경 버튼
    @IBAction func changeCategory(_ sender: UIButton) {
        menu?.show()
        menu?.anchorView = sender
        guard let height = menu?.anchorView?.plainView.bounds.height else { return }
        menu?.bottomOffset = CGPoint(x: 0, y: height)
        menu?.width = view.frame.width / 2
        menu?.backgroundColor = UIColor.systemGray6
        menu?.textColor = .label
        menu?.selectionAction = { [weak self] (index: Int, item: Todo.toDoCategory.RawValue) in
            self?.toDoCategoryLabel.text = item
            
            switch item {
            case "업무":
                self?.selectedTodo?.toDoCategory = .duty
            case "개인":
                self?.selectedTodo?.toDoCategory = .study
            case "운동":
                self?.selectedTodo?.toDoCategory = .workout
            default:
                break
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeCategoryButton.contentHorizontalAlignment = .leading
        contentTextField.text = selectedTodo?.content
        dateTimeLabel.text = selectedTodo?.insertDate.dateToString
        detailTextView.isHidden = false
        toggleIsMarkedButton.setTitle("", for: .normal)
        
        
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
        
        selectedTodo?.content = content
    }
}
