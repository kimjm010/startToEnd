//
//  DiaryComposeViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit
import AVFoundation
import CoreData


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
    
    @IBOutlet var accessoryBar: UIToolbar!
    
    @IBOutlet weak var separationView: UIView!
    
    @IBOutlet weak var composeTextViewBottonConstraint: NSLayoutConstraint!
    
    /// 일기 정보 저장 속성
    var diary: MyDiaryEntity?
    
    /// 일기에 첨부할 이미지 배열
    var imageList = [UIImage]()
    
    var photos = [PhotoGalleryEntity]()

    
    var composeTag: Int?
    
    var token: NSManagedObject?
    
    
    /// 일기 작성 화면을 닫습니다.
    /// - Parameter sender: Cancel 버튼
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 일기를 저장합니다.
    /// - Parameter sender: Save 버튼
    @IBAction func saveDiary(_ sender: Any) {
        
        let image = UIImage(data: photos.first?.image ?? Data())
        guard let content = contentTextView.text, let status = emotionImageView.image else { return }
        
        DataManager.shared.createDiary(content: content,
                                       insertDate: datePicker.date,
                                       statusImage: status.pngData(),
                                       image: image?.pngData()) {
            NotificationCenter.default.post(name: .didInsertNewDiary, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /// 뷰가 화면에 표시되기 직전에 호출됩니다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageCollectionView.isHidden = imageList.count == 0
        separationView.isHidden = imageCollectionView.isHidden
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        photos = DataManager.shared.retrieveImagesData()
        imageCollectionView.reloadData()
        
        NotificationCenter.default.addObserver(forName: .didSelectEmotionImage, object: nil, queue: .main) { [weak self] (noti) in
            guard let emotion = noti.userInfo?["newImage"] as? UIImage else { return }
            self?.emotionImageView.image = emotion
        }
        
        NotificationCenter.default.addObserver(forName: .imageDidSelect, object: nil, queue: .main) { [weak self] (noti) in
            guard let image = noti.userInfo?["image"] as? UIImage else { return }
            self?.imageList.append(image)
            self?.imageCollectionView.reloadData()
        }
        
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            guard let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            let height = frame.height
            var inset = self.contentTextView.contentInset
            inset.bottom = height
            self.contentTextView.contentInset = inset
            
            inset = self.contentTextView.verticalScrollIndicatorInsets
            inset.bottom = height
            self.contentTextView.verticalScrollIndicatorInsets = inset
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            var inset = self.contentTextView.contentInset
            inset.bottom = 0
            self.contentTextView.contentInset = inset
            self.contentTextView.verticalScrollIndicatorInsets = inset
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
        contentTextView.inputAccessoryView = accessoryBar
        contentTextView.backgroundColor = backgroungView.backgroundColor
        contentTextView.alpha = 0.5
        
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




extension DiaryComposeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachedImageCollectionViewCell", for: indexPath) as! AttachedImageCollectionViewCell
        
        let target = imageList[indexPath.item]
        cell.configure(image: target)
        return cell
    }
}



 
extension DiaryComposeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageList.remove(at: indexPath.item)
        imageCollectionView.deleteItems(at: [indexPath])
        imageCollectionView.reloadData()
    }
}




extension DiaryComposeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
}
