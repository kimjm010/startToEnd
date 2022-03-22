//
//  ImageDisplayViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/09.
//

import UIKit
import Photos


/// 앨범 이미지 표시 화면
class ImageDisplayViewController: CommonViewController {
    
    /// 이미지 리스트 컬렉션 뷰
    @IBOutlet weak var listCollectionView: UICollectionView!

    /// Fetch한 사진 저장
    var allPhotos: PHFetchResult<PHAsset> = {
        let option = PHFetchOptions()
        
        let sortByDateDesc = NSSortDescriptor(key: "creationDate", ascending: false)
        option.sortDescriptors = [sortByDateDesc]
        
        return PHAsset.fetchAssets(with: option)
    }()
    
    /// 이미지 관리 객체
    let imageManager = PHImageManager()
    
    
    var imageList = [UIImage]()
    
    var selectedImage: UIImage?
    
    /// 앨범 이미지 표시 화면을 닫습니다.
    /// - Parameter sender: Cancel 버튼
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 선택한 이미지를 첨부합니다.
    /// - Parameter sender: Select 버튼
    @IBAction func selectAttachedImages(_ sender: Any) {
        guard let indexPath = listCollectionView.indexPathsForSelectedItems else { return }
        
        for index in indexPath {
            let target = allPhotos.object(at: index.item)
            let size = CGSize(width: listCollectionView.frame.width / 2,
                              height: listCollectionView.frame.width / 2)
            
            imageManager.requestImage(for: target, targetSize: size, contentMode: .aspectFit, options: nil) { [weak self] (image, _) in
                if let image = image {
                    self?.imageList.append(image)
                }
            }
            
            let userInfo = ["image": imageList]
            NotificationCenter.default.post(name: .imageDidSelect, object: nil, userInfo: userInfo)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func requestAuthorization() {
        let status: PHAuthorizationStatus
        
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        
        switch status {
        case .notDetermined:
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] (selectedStatus) in
                    switch selectedStatus {
                    case .authorized, .limited:
                        break
                    default:
                        self?.alertAccessPhotoLibrary()
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { [weak self] (selectedStatus) in
                    
                    switch selectedStatus {
                    case .authorized, .limited:
                        break
                    default:
                        self?.alertAccessPhotoLibrary()
                    }
                }
            }
        case .restricted:
            alertAccessPhotoLibrary()
        case .denied:
            alertAccessPhotoLibrary()
        case .authorized, .limited:
            break
        @unknown default:
            alertAccessPhotoLibrary()
        }
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAuthorization()
        listCollectionView.allowsMultipleSelection = true
        
        PHPhotoLibrary.shared().register(self)
    }
    
    /// 소멸자에서 옵저버를 제거
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}





extension ImageDisplayViewController: UICollectionViewDataSource {
    
    /// 이미지 수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: listCollectionView
    ///   - section: 이미지 목록을 나누는 section Index
    /// - Returns: 접근 가능한 이미지 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    
    /// 이미지 표시를 위한 셀을 구성합니다.
    /// - Parameters:
    ///   - collectionView: listCollectionView
    ///   - indexPath: 이미지 셀의 indexPath
    /// - Returns: 이미지 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplayImagesCollectionViewCell", for: indexPath) as! DisplayImagesCollectionViewCell
        
        let target = allPhotos.object(at: indexPath.item)
        let size = CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
        imageManager.requestImage(for: target, targetSize: size, contentMode: .aspectFit, options: nil) { (image, _) in
            cell.configure(img: image)
        }
        
        return cell
    }
}




extension ImageDisplayViewController: UICollectionViewDelegateFlowLayout {
    
    /// 이미지 셀의 사이즈를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: listCollectionView
    ///   - collectionViewLayout: listCollectionView 레이아웃 정보
    ///   - indexPath: 이미지 셀의 indexPath
    /// - Returns: 이미지 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 4,
                      height: collectionView.frame.width / 4)
    }
}





extension ImageDisplayViewController: PHPhotoLibraryChangeObserver {
    
    /// photoLibrary애 변화가 있을 경우 호출됩니다.
    /// - Parameter changeInstance: 변경 사항을 나타내는 객체
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            if let changes = changeInstance.changeDetails(for: self.allPhotos) {
                self.allPhotos = changes.fetchResultAfterChanges
                self.listCollectionView.reloadData()
            }
        }
    }
}
