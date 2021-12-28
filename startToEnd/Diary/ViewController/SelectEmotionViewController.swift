//
//  SelectEmotionViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit


/// 감정 이미지 선택 화면
class SelectEmotionViewController: UIViewController {

    /// 감정 이미지를 표시합니다.
    ///
    /// 감정이미지는 총 60개입니다.
    var emotionList: [UIImage] = {
        var list = [UIImage]()
        for num in 1...60 {
            let image = UIImage(named: "\(num)")
            guard let image = image else { return [UIImage]() }
            list.append(image)
        }
        
        return list
    }()
    
    
    /// 감정 이미지 선택화면을 닫습니다.
    /// - Parameter sender: Cancel 버튼
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}




extension SelectEmotionViewController: UICollectionViewDataSource {
    
    /// 감정 이미지 수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 감정 이미지 컬렉션 뷰
    ///   - section: 감정 이미지 목록을 나누는 section Index
    /// - Returns: 감정 이미지 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotionList.count
    }
    
    
    /// 감정 이미지 목록 셀을 설정합니다.
    /// - Parameters:
    ///   - collectionView: 감정 이미지 컬렉션 뷰
    ///   - indexPath: 감정 이미지 목록 셀의 indexPath
    /// - Returns: 감정 이미지 목록 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmotionCollectionViewCell", for: indexPath) as! EmotionCollectionViewCell
        
        let target = emotionList[indexPath.item]
        cell.configure(image: target)
        return cell
    }
}




extension SelectEmotionViewController: UICollectionViewDelegate {
    
    /// 감정 이미지 셀을 선택했을 때의 동작을 설정합니다.
    /// - Parameters:
    ///   - collectionView: 감정 이미지 컬렉션 뷰
    ///   - indexPath: 선택한 셀의 indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedImage = emotionList[indexPath.item]
        
        let userInfo = ["newImage": selectedImage]
        NotificationCenter.default.post(name: .didSelectEmotionImage, object: nil, userInfo: userInfo)
        
        NotificationCenter.default.post(name: .didUpdateEmotionImage, object: nil, userInfo: userInfo)
        dismiss(animated: true, completion: nil)
    }
}




extension SelectEmotionViewController: UICollectionViewDelegateFlowLayout {
    
    /// 감정 이미지 셀의 사이즈를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 감정 이미지 컬렉션 뷰
    ///   - collectionViewLayout: 감정 이미지 컬렉션 뷰 레이아웃 정보
    ///   - indexPath: 감정 이미지 셀의 indexPath
    /// - Returns: 감정 이미지 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.width / 5)
    }
}
