//
//  DiaryComposeViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit
import AVFoundation
import CoreData


/// 일기 작성 화면
class DiaryComposeViewController: CommonViewController {
    
    /// 이미지 컬렉션 뷰
    ///
    /// 첨부할 이미지를 표시합니다.
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    /// 감정상태 선택 버튼
    @IBOutlet weak var selectEmotionImageButton: UIButton!
    
    /// 감정상태를 표시하는 이미지 뷰
    @IBOutlet weak var emotionImageView: UIImageView!
    
    /// 일기 내용 텍스트 뷰
    @IBOutlet weak var contentTextView: UITextView!
    
    /// placeholder레이블
    ///
    /// 일기 작성 방법을 설명합니다.
    @IBOutlet weak var placeholderLabel: UILabel!
    
    /// 데이트 피커
    ///
    /// 일기 입력 날짜를 선택합니다.
    @IBOutlet weak var datePicker: UIDatePicker!
    
    /// 배경 뷰
    @IBOutlet weak var backgroungView: UIView!
    
    /// 앨범 버튼을 포함한 툴바
    @IBOutlet var accessoryBar: UIToolbar!
    
    /// 이미지 separation뷰
    @IBOutlet weak var separationView: UIView!
    
    /// 텍스트 뷰 bottom 제약
    @IBOutlet weak var composeTextViewBottonConstraint: NSLayoutConstraint!
    
    /// 일기 정보 저장 속성
    var diary: MyDiaryEntity?
    
    /// 일기 목록을 확인하는 속성
    ///
    /// tag값에 따라 다른 배경의 일기작성 화면을 표시합니다.
    var composeTag: Int?
    
    /// 첨부한 이미지 배열
    var imageList = [UIImage]()
    
    /// 첨부한 이미지 데이터 배열
    var attachedImageDataList = [Data]()
    
    var statusImage: UIImage?
    
    var statusImageData: Data?
    
    var diaryImageData: Data?
    
    /// 일기 작성 화면을 닫습니다.
    /// - Parameter sender: Cancel 버튼
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 일기를 저장합니다.
    /// - Parameter sender: Save 버튼
    @IBAction func saveDiary(_ sender: Any) {
        
        guard let content = contentTextView.text else { return }
        
        DataManager.shared.createMyDiary(content: content,
                                         insertDate: datePicker.date,
                                         statusImageData: statusImageData,
                                         diaryImageData: diaryImageData) {
            NotificationCenter.default.post(name: .didInsertNewDiary, object: nil)
        }
        
        self.dismiss(animated: true, completion: nil)
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
        DataManager.shared.fetchDiary()
        imageCollectionView.reloadData()
        
        
        // 선택한 감정상태를 배경화면으로 지정합니다.
        var token = NotificationCenter.default.addObserver(forName: .didSelectEmotionImage,
                                                           object: nil,
                                                           queue: .main) { [weak self] (noti) in
            guard let emotionImage = noti.userInfo?["emotion"] as? UIImage else { return }
            let emotionImageData = emotionImage.pngData()
            DataManager.shared.saveEmoImage(imageData: emotionImageData) {
                self?.emotionImageView.image = emotionImage
            }
        }
        tokens.append(token)
        
        
        // 선택한 이미지를 표시합니다.
        token = NotificationCenter.default.addObserver(forName: .imageDidSelect,
                                                       object: nil,
                                                       queue: .main, using: { [weak self] (noti) in
            guard let self = self else { return }
            guard let diaryImages = noti.userInfo?["image"] as? [UIImage] else { return }
            self.imageList.append(contentsOf: diaryImages)
            
            for num in 0...self.imageList.count {
                let singleImageData = self.imageList[num].pngData()
                DataManager.shared.saveDiaryImage(data: singleImageData) {
                    print(#function, "^^^^여기서 뭘해야하나")
                }
            }
        })
        tokens.append(token)
        
        
        // contentTextView 키보드를 표시한만큼 높이를 조정합니다.
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] (noti) in
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
        tokens.append(token)
        
        
        // contentTextView 키보드를 숨긴만큼 높이를 조정합니다.
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            var inset = self.contentTextView.contentInset
            inset.bottom = 0
            self.contentTextView.contentInset = inset
            self.contentTextView.verticalScrollIndicatorInsets = inset
        }
        tokens.append(token)
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
        
        // tag값에 따라 서로 다른 배경화면을 표시합니다.
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
    
    /// 일기 편집 시 placeholder를 숨깁니다.
    /// - Parameter textView: contentTextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    
    /// 일기 편집 후 placeholder상태를 관리합니다.
    ///
    /// 편집 후 글자 수가 0인 경우 placeholder를 다시 표시합니다.
    /// - Parameter textView: contentTextView
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
    
    /// 이미지 수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - section: 이미지 목록을 나누는 section indexPath
    /// - Returns: 첨부할 이미지 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return DataManager.shared.photoList.count
        return imageList.count
    }
    
    
    /// 첨부할 이미지 목록 셀을 설정합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - indexPath: 이미지 셀의 indexPath
    /// - Returns: 이미지 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachedImageCollectionViewCell", for: indexPath) as! AttachedImageCollectionViewCell
        
        //let target = DataManager.shared.photoList[indexPath.item]
        let target = imageList[indexPath.row]
        cell.configure(image: target)
        return cell
    }
}




extension DiaryComposeViewController: UICollectionViewDelegate {
    
    /// 이미지 셀을 선택했을 때의 동작을 설정합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - indexPath: 선택한 셀의 indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageList.remove(at: indexPath.item)
        imageCollectionView.deleteItems(at: [indexPath])
    }
}




extension DiaryComposeViewController: UICollectionViewDelegateFlowLayout {
    
    /// 이미지 셀의 사이즈를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: imageCollectionView
    ///   - collectionViewLayout: imageCollectionView 레이아웃 정보
    ///   - indexPath: 이미지 셀의 indexPath
    /// - Returns: 이미지 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
}
