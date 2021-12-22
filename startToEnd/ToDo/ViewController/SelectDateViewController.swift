//
//  SelectDateViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/16.
//

import UIKit


/// 날짜 선택 화면
class SelectDateViewController: UIViewController {
    
    /// 날짜 선택 datePicker
    ///
    /// 업데이트할  날짜 데이트 피커
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        datePicker.datePickerMode = .date
    }
    
    
    /// 뷰가 계층에서 사라지기 전에 호출됩니다.
    /// - Parameter animated: animation 여부
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        var userInfo = ["newDate": datePicker.date]
        NotificationCenter.default.post(name: .setNewDate, object: nil, userInfo: userInfo)
        dismiss(animated: true, completion: nil)
        
        userInfo = ["dueDate": datePicker.date]
        NotificationCenter.default.post(name: .updateDueDate, object: nil, userInfo: userInfo)
    }
}
