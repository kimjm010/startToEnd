//
//  DiaryDetailViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit
import CoreData


/// 일기 Detail 화면
class DiaryDetailViewController: CommonViewController {
    
    /// 배경 이미지 뷰
    @IBOutlet weak var emotionBackgroungImageView: UIImageView!
    
    /// 첨부한 이미지 표시 컬렉션 뷰
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    /// 감정 이모지 변경 버튼
    @IBOutlet weak var changeEmotionImageButton: UIButton!
    
    /// 날자 레이블 컨테이너 뷰
    @IBOutlet weak var dateLabelContainerView: UIView!
    
    /// 일기 내용 작성 텍스트 뷰
    @IBOutlet weak var contentTextView: UITextView!
    
    /// 날짜 레이블
    @IBOutlet weak var createdDateLabel: UILabel!
    
    /// 구분하기위한 뷰
    @IBOutlet weak var separationView: UIView!
    
    /// MyDiaryEntity 객체
    var diary: MyDiaryEntity?
    
    /// 첨부한 이미지 배열
    var imageList = [UIImage]()
    
    var target: NSManagedObject?


    /// 뷰가 화면에 표시되기 직전에 호출됩니다.
    /// - Parameter animated: 애니메이션 여부
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listCollectionView.isHidden = imageList.count == 0
        separationView.isHidden = listCollectionView.isHidden
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        
        print(diary?.content, diary?.insertDate)
        
        var token = NotificationCenter.default.addObserver(forName: .didUpdateEmotionImage, object: nil, queue: .main) { [weak self] (noti) in
            guard let newEmotion = noti.userInfo?["newImage"] as? UIImage else { return }
            
            
            self?.emotionBackgroungImageView.image = newEmotion
        }
        tokens.append(token)
        
        
        // 다이어리를 업데이트 합니다.
        if let diary = diary,
           let content = contentTextView.text {
            DataManager.shared.updateDiary(entity: diary,
                                           content: content) {
                NotificationCenter.default.post(name: .didUpdateDiary, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
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
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            var inset = self.contentTextView.contentInset
            inset.bottom = 0
            self.contentTextView.contentInset = inset
            self.contentTextView.verticalScrollIndicatorInsets = inset
        }
        tokens.append(token)
    }
    
    
    /// 필요한 데이터를 초기화합니다.
    func initializeData() {
        guard let diary = diary,
              let statusImageUrl = URL(string: diary.statusImageUrl ?? "") else { return }
        
        dateLabelContainerView.applyBigRoundedRect()
        createdDateLabel.text = "Date: \(diary.insertDate!.dateToString)"
        contentTextView.text = diary.content
        changeEmotionImageButton.setTitle("", for: .normal)
        listCollectionView.isHidden = imageList.count == 0
        
        do {
            let statusImageData = try Data(contentsOf: statusImageUrl)
            emotionBackgroungImageView.image = UIImage(data: statusImageData)
        } catch {
            print("데이터 Initiailize 시 에러 발생했습니다!!!!")
        }
    }
}




extension DiaryDetailViewController: UITextViewDelegate {
    
    /// 편집 후 편집 여부에 따라 일기의 내용을 업데이트 합니다.
    /// - Parameter textView: contentTextView
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
    
    /// 이미지의 수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 이미지 목록 컬렉션 뷰
    ///   - section: 이미지 목록을 나누는 section indexPath
    /// - Returns: 첨부한 이미지 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    
    /// 첨부한 이미지 목록 셀을 설정합니다.
    /// - Parameters:
    ///   - collectionView: 이미지 컬렉션 뷰
    ///   - indexPath: 이미지 셀의 indexPath
    /// - Returns: 이미지 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        let target = imageList[indexPath.item]
        cell.configure(image: target)
        return cell
    }
}




extension DiaryDetailViewController: UICollectionViewDelegateFlowLayout {
    
    ///  이미지 셀의 사이즈를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 이미지 컬렉션 뷰
    ///   - collectionViewLayout: 컬렉션 뷰의 레이아웃 정보
    ///   - indexPath: 이미지 셀의 indexPath
    /// - Returns: 이미지 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
