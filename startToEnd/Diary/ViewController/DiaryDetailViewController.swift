//
//  DiaryDetailViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit
import CoreData


extension NSNotification.Name {
    static let didUpdateDiary = Notification.Name(rawValue: "didUpdateDiary")
}


class DiaryDetailViewController: UIViewController {
    
    @IBOutlet weak var emotionBackgroungImageView: UIImageView!
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    @IBOutlet weak var changeEmotionImageButton: UIButton!
    
    @IBOutlet weak var dateLabelContainerView: UIView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var createdDateLabel: UILabel!
    
    @IBOutlet weak var separationView: UIView!
    
    var diary: MyDiaryEntity?
    
    var imageList = [UIImage]()
    
    var photos = [PhotoGalleryEntity]()
    
    var target: NSManagedObject?


    /// 뷰가 화면에 표시되기 직전에 호출됩니다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listCollectionView.isHidden = imageList.count == 0
        separationView.isHidden = listCollectionView.isHidden
        
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        
        NotificationCenter.default.addObserver(forName: .didUpdateEmotionImage, object: nil, queue: .main) { [weak self] (noti) in
            guard let newEmotion = noti.userInfo?["newImage"] as? UIImage else { return }
            
            self?.diary?.statusImage = newEmotion.pngData()
            self?.emotionBackgroungImageView.image = newEmotion
        }
        
        if let target = target as? MyDiaryEntity {
            
            guard let diary = diary else { return }
            
            let updatedDiary = MyDiary(content: diary.content,
                                       insertDate: diary.insertDate ?? Date(),
                                       statusImage: UIImage(data: diary.statusImage!))
            
            DataManager.shared.updateDiary(entity: target,
                                           content: updatedDiary.content ?? diary.content!,
                                           insertDate: updatedDiary.insertDate,
                                           statusImage: updatedDiary.statusImage?.pngData()) {
                let userInfo = ["updated": updatedDiary]
                NotificationCenter.default.post(name: .didUpdateDiary,
                                                object: nil,
                                                userInfo: userInfo)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let height = frame.height
                var inset = self.contentTextView.contentInset
                inset.bottom = height
                self.contentTextView.contentInset = inset
                
                inset = self.contentTextView.verticalScrollIndicatorInsets
                inset.bottom = height
                self.contentTextView.verticalScrollIndicatorInsets = inset
            }
        }
        
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            var inset = self.contentTextView.contentInset
            inset.bottom = 0
            self.contentTextView.contentInset = inset
            self.contentTextView.verticalScrollIndicatorInsets = inset
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    /// 필요한 데이터를 초기화합니다.
    func initializeData() {
        guard let diary = diary, let defaultImageData = UIImage(named: "1")?.pngData() else { return }
        
        dateLabelContainerView.applyBigRoundedRect()
        emotionBackgroungImageView.image = UIImage(data: diary.statusImage ?? defaultImageData)
        createdDateLabel.text = "Date: \(diary.insertDate!.dateToString)"
        contentTextView.text = diary.content
        changeEmotionImageButton.setTitle("", for: .normal)
        listCollectionView.isHidden = imageList.count == 0
    }
}




extension DiaryDetailViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let updated = textView.text else { return }
        
        let originalText = diary?.content
        
        if originalText != updated {
            diary?.content = updated
            guard var updatedDate = diary?.insertDate else { return }
            updatedDate = Date()
            createdDateLabel.text = updatedDate.dateToString
            diary?.insertDate = updatedDate
        }
    }
}





extension DiaryDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        let target = imageList[indexPath.item]
        cell.configure(image: target)
        return cell
    }
}




extension DiaryDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
