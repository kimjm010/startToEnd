//
//  DiaryDetailViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit


extension NSNotification.Name {
    static let updatedDiaryDidInsert = Notification.Name(rawValue: "updatedDiaryDidInsert")
}


class DiaryDetailViewController: UIViewController {
    
    @IBOutlet weak var emotionBackgroungImageView: UIImageView!
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    @IBOutlet weak var changeEmotionImageButton: UIButton!
    
    @IBOutlet weak var dateLabelContainerView: UIView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var createdDateLabel: UILabel!
    
    @IBOutlet weak var separationView: UIView!
    
    var diary: MyDiary?
    
    var imageList = [UIImage]()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listCollectionView.isHidden = imageList.count == 0
        separationView.isHidden = listCollectionView.isHidden
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        
        NotificationCenter.default.addObserver(forName: .didUpdateEmotionImage, object: nil, queue: .main) { [weak self] (noti) in
            guard let newEmotion = noti.userInfo?["newImage"] as? UIImage else { return }
            
            self?.diary?.statusImage = newEmotion
            self?.emotionBackgroungImageView.image = newEmotion
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
        guard let diary = diary else { return }
        
        
        let updatedDiary = MyDiary(content: diary.content,
                                   insertDate: diary.insertDate,
                                   statusImage: diary.statusImage)
        
        let userInfo = ["updated": updatedDiary]
        NotificationCenter.default.post(name: .updatedDiaryDidInsert,
                                        object: nil,
                                        userInfo: userInfo)
    }
    
    
    /// 필요한 데이터를 초기화합니다.
    func initializeData() {
        
        dateLabelContainerView.applyBigRoundedRect()
        emotionBackgroungImageView.image = diary?.statusImage
        guard let date = diary?.insertDate else { return }
        createdDateLabel.text = "Created Data: \(date.dateToString)"
        contentTextView.text = diary?.content
        changeEmotionImageButton.setTitle("", for: .normal)
        
        guard let list = diary?.images else { return }
        imageList = list
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
            createdDateLabel.text = "Updated Date: \(updatedDate.dateToString)"
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
