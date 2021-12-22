//
//  DetailViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/01.
//

import UIKit
import UserNotifications
import CoreData
import DropDown


class DetailViewController: UIViewController {
    
    /// 반복 설정 컨테이너 뷰
    @IBOutlet weak var repeatNotificationContainerView: UIStackView!
    
    /// textView placeholder 레이블
    @IBOutlet weak var detailTextViewPlaceholder: UILabel!
    
    /// todo Content 텍스트 필드
    @IBOutlet weak var todoContentTextField: UITextField!
        
    /// Mark 토글 버튼
    @IBOutlet weak var toggleIsMarkedButton: UIButton!
    
    /// 기한날짜 선택 버튼
    @IBOutlet weak var selectDueDateButton: UIButton!
    
    /// Mark 이미지 뷰
    @IBOutlet weak var MarkedImageView: UIImageView!
    
    /// 메모 textView
    @IBOutlet weak var detailTextView: UITextView!
    
    /// 알림 반복 선택 스위치
    @IBOutlet weak var repeatNotiSwitch: UISwitch!
    
    /// 알림 기한 레이블
    @IBOutlet weak var dueDateLabel: UILabel!
    
    /// 알림 일정 지정 속성
    @IBOutlet weak var datePicker: UIDatePicker!
    
    /// 알림 설정 switch
    @IBOutlet weak var notiSwitch: UISwitch!
    
    /// category 배열
    var categoryList = Category2.allCases
    
    /// 선택된 toDoList의 카테고리 속성
    var selectedCategoryRawvalue: Int?
    
    /// 옵저버 제거를 위해 토큰을 담는 배열
    var tokens = [NSObjectProtocol]()
    
    /// 선택된 todo
    var selectedTodo: TodoEntity?
    
    /// todo 데이터 저장 속성
    var reallySelectedTodo: Todo?
    
    var target: NSManagedObject?
    
    /// 반복 알림 컨테이버 뷰 표시 유무 확인 속성
    var isPresent: Bool = false
    
    /// 반복 알림 저장 속성
    var isRepeat: Bool = false
    
    
    /// MarkImageView를 토글합니다.
    /// - Parameter sender: toggleIsMarkedButton
    @IBAction func toggleMark(_ sender: UIButton) {
        
        guard let selectedTodo = selectedTodo else { return }

        MarkedImageView.isHighlighted = !(selectedTodo.isMarked) ? true : false
        selectedTodo.isMarked = !(selectedTodo.isMarked) ? true : false
    }
    
    
    /// 알림 여부를 선택합니다.
    /// - Parameter sender: notiSwitch
    @IBAction func toggleNotification(_ sender: Any) {
        isPresent = isPresent ? false : true
        repeatNotificationContainerView.isHidden = !isPresent
        selectedTodo?.reminder = isPresent
        notiSwitch.isOn = isPresent
    }
    
    
    /// 알림 반복 여부를 선탭합니다.
    /// - Parameter sender: repeatNotiSwitch
    @IBAction func toggleRepeatNotification(_ sender: Any) {
        isRepeat = isRepeat ? false : true
        selectedTodo?.isRepeat = isRepeat
        repeatNotiSwitch.isOn = isRepeat
    }
    
    @IBAction func selectNotiDate(_ sender: Any) {
        selectedTodo?.notiDate = datePicker.date
        datePicker.locale = Locale(identifier: "ko_kr")
    }
    
    
    /// 업데이트된 todo를 저장합니다.
    /// - Parameter sender: Update 버튼
    @IBAction func updateSelectedToDo(_ sender: Any) {
        guard let content = todoContentTextField.text, let memo = detailTextView.text else { return }
        if let selectedTodo = selectedTodo {
            selectedTodo.content = content
            selectedTodo.isMarked = selectedTodo.isMarked
            selectedTodo.insertDate = selectedTodo.insertDate
            selectedTodo.reminder = selectedTodo.reminder
            selectedTodo.notiDate = datePicker.date
            selectedTodo.isRepeat = selectedTodo.isRepeat
            selectedTodo.memo = memo
            DataManager.shared.saveMainContext()
            
            NotificationManager.shared.sendNotification(seconds: 5)
            print(selectedTodo.reminder)
            
            if selectedTodo.reminder {
                NotificationManager.shared.scheduleNotification(todo: selectedTodo, repeats: selectedTodo.isRepeat)
            }
            
            NotificationCenter.default.post(name: .updateToDo, object: nil)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /// toDo Detail화면을 닫습니다.
    /// - Parameter sender: Cancel 버튼
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    
    /// 필요한 데이터를 초기화합니다.
    func initializeData() {
        guard let selectedTodo = selectedTodo else { return }

        dueDateLabel.text = selectedTodo.insertDate?.dateToString
        todoContentTextField.text = selectedTodo.content
        detailTextView.text = selectedTodo.memo
        notiSwitch.isOn = selectedTodo.reminder
        repeatNotiSwitch.isOn = selectedTodo.isRepeat
        detailTextView.isHidden = false
        toggleIsMarkedButton.setTitle("", for: .normal)
        selectDueDateButton.setTitle("", for: .normal)
        datePicker.date = selectedTodo.notiDate ?? Date()
        repeatNotificationContainerView.isHidden = notiSwitch.isOn ? false : true
        detailTextViewPlaceholder.isHidden = detailTextView.text.count > 0
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        
        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] (noti) in
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
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            
            self.detailTextView.contentInset.bottom = 0
            self.detailTextView.verticalScrollIndicatorInsets.bottom = 0
        }
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .updateDueDate, object: nil, queue: .main, using: { [weak self] (noti) in
            guard let updatedDueDate = noti.userInfo?["dueDate"] as? Date else { return }
            self?.selectedTodo?.insertDate = updatedDueDate
            self?.dueDateLabel.text = updatedDueDate.dateToString
        })
        tokens.append(token)
    }
    
    
    /// 뷰가 계층에서 사라지기 전에 호출됩니다.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    /// 소멸자에서 옵저버를 제거
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
        
        NotificationManager.shared.removeScheduledNotification(todo: selectedTodo)
    }
}




extension DetailViewController: UITextViewDelegate {
    
    /// textView를 편집할 때 placeholder레이블을 숨깁니다.
    /// - Parameter textView: detailTextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        detailTextViewPlaceholder.isHidden = true
    }
    
    
    /// 편집 후 textView의 글자 수에 따라 placeholder레이블을 표시합니다.
    /// - Parameter textView: detailTextView
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let content = textView.text, content.count > 0 else {
            detailTextViewPlaceholder.isHidden = false
            return
        }
        
        detailTextViewPlaceholder.isHidden = true
    }
}
