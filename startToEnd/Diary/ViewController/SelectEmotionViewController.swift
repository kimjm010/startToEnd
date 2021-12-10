//
//  SelectEmotionViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit


extension NSNotification.Name {
    static let didSelectEmotionImage = Notification.Name(rawValue: "didSelectEmotionImage")
    
    static let didUpdateEmotionImage = Notification.Name(rawValue: "didUpdateEmotionImage")
}


class SelectEmotionViewController: UIViewController {

    var emotionList: [UIImage] = {
        var list = [UIImage]()
        for num in 1...60 {
            let image = UIImage(named: "\(num)")
            guard let image = image else { return [UIImage]() }
            list.append(image)
        }
        
        return list
    }()
    
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}




extension SelectEmotionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmotionCollectionViewCell", for: indexPath) as! EmotionCollectionViewCell
        
        let target = emotionList[indexPath.item]
        cell.configure(image: target)
        return cell
    }
}




extension SelectEmotionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedImage = emotionList[indexPath.item]
        
        let userInfo = ["newImage": selectedImage]
        NotificationCenter.default.post(name: .didSelectEmotionImage, object: nil, userInfo: userInfo)
        
        NotificationCenter.default.post(name: .didUpdateEmotionImage, object: nil, userInfo: userInfo)
        dismiss(animated: true, completion: nil)
    }
}




extension SelectEmotionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.width / 5)
    }
}
