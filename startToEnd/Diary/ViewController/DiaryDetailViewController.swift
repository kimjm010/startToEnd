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
    
    @IBOutlet weak var updatedDateLabel: UILabel!
    
    var diary: MyDiary?
    
    var imageList = [UIImage]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
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
        guard let list = diary?.images else { return }

        dateLabelContainerView.applyBigRoundedRect()
        emotionBackgroungImageView.image = diary?.statusImage
        createdDateLabel.text = diary?.insertDate.dateToString
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
            diary?.insertDate = Date()
            updatedDateLabel.text = diary?.insertDate.dateToString
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
