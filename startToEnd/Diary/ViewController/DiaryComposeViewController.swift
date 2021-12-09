//
//  DiaryComposeViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit


extension NSNotification.Name {
    static let didInsertNewDiary = Notification.Name(rawValue: "didInsertNewDiary")
}


class DiaryComposeViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var selectEmotionImageButton: UIButton!
    
    @IBOutlet weak var emotionImageView: UIImageView!

    @IBOutlet weak var currentLocationLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var backgroungView: UIView!
    
    /// 일기 정보 저장 속성
    var diary: MyDiary?
    
    /// 일기에 첨부할 이미지 배열
    var imageList = [UIImage]()
    
    var composeTag: Int?
    
    /// 일기 작성 화면을 닫습니다.
    /// - Parameter sender: Cancel 버튼
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 일기를 저장합니다.
    /// - Parameter sender: Save 버튼
    @IBAction func saveDiary(_ sender: Any) {
        
        let newDiary = MyDiary(content: contentTextView.text, insertDate: datePicker.date, statusImage: emotionImageView.image)
        
        let userInfo = ["newDiary": newDiary]
        NotificationCenter.default.post(name: .didInsertNewDiary, object: nil, userInfo: userInfo)
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        
        NotificationCenter.default.addObserver(forName: .didSelectEmotionImage, object: nil, queue: .main) { [weak self] (noti) in
            guard let emotion = noti.userInfo?["newImage"] as? UIImage else { return }
            self?.emotionImageView.image = emotion
        }
    }
    
    
    /// 화면을 닫기전에 실행됩니다.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
    
    
    /// 필요한 데이터를 초기화합니다.
    func initializeData() {
        selectEmotionImageButton.setTitle("", for: .normal)
        imageCollectionView.isHidden = imageList.count == 0
        
        switch composeTag {
        case 101:
            backgroungView.backgroundColor = UIColor.systemRed
        case 102:
            backgroungView.backgroundColor = UIColor.systemGreen
        case 103:
            backgroungView.backgroundColor = UIColor.systemBlue
        default:
            break
        }
    }
}




extension DiaryComposeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let content = textView.text, content.count > 0 else {
            placeholderLabel.isHidden = false
            return
        }
        
        diary?.content = content
        placeholderLabel.isHidden = true
    }
}
