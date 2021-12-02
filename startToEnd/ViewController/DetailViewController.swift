//
//  DetailViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/01.
//

import UIKit
import DropDown


extension Notification {
    static let updateToDo = Notification.Name(rawValue: "updateToDo")
}

class DetailViewController: UIViewController {

    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var toggleMarkButton: UIButton!
    
    @IBOutlet weak var changeCategoryButton: UIButton!
    
    @IBOutlet weak var toDoCategoryLabel: UILabel!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var detailTextViewPlaceholder: UILabel!
    
    /// todo 데이터 저장 속성
    var todo: Todo?
    
    /// todoCategory 저장 속성
    var toDoCategory: Todo.toDoCategory?
    
    /// Mark표시 저장 속성
    var isMarked: Bool?
    
    /// DropDown메뉴 표시 속성
    lazy var menu: DropDown? = {
       let menu = DropDown()
        // TODO: 데이터 넣는 방법 수정할 것
        menu.dataSource = ["업무", "개인", "운동"]
        return menu
    }()
    
    
    @IBAction func toggleMark(_ sender: UIButton) {
        print(#function)
        guard var isMarked = isMarked else { return }

        isMarked = true
        
        if isMarked {
            toggleMarkButton.setImage(UIImage(systemName: "star.fill"), for: .highlighted)
        } else {
            toggleMarkButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeCategoryButton.contentHorizontalAlignment = .leading
        contentLabel.text = todo?.content
        dateTimeLabel.text = todo?.insertDate.dateToString
        isMarked = todo?.isMarked
        toggleMarkButton.setTitle("", for: .normal )
        detailTextView.isHidden = false
        
        
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
        menu?.selectionAction = { [weak self] (index: Int, item: String) in
            self?.toDoCategoryLabel.text = item
        }
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
