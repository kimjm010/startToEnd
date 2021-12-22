//
//  ImageDisplayViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/09.
//

import UIKit
import Photos


extension NSNotification.Name {
    
}



class ImageDisplayViewController: UIViewController {
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    @IBOutlet weak var editImageListButton: UIBarButtonItem!

    var allPhotos: PHFetchResult<PHAsset> = {
        let option = PHFetchOptions()
        
        let sortByDateDesc = NSSortDescriptor(key: "creationDate", ascending: false)
        option.sortDescriptors = [sortByDateDesc]
        
        return PHAsset.fetchAssets(with: option)
    }()
    
    let imageManager = PHImageManager()
    
    
    @IBAction func editSelectedImageList(_ sender: Any) {
        if #available(iOS 14, *) {
            //PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
        }
    }
    
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectAttachedImages(_ sender: Any) {
        print(#function)
        guard let indexPath = listCollectionView.indexPathsForSelectedItems else { return }
        
        for index in indexPath {
            let target = allPhotos.object(at: index.item)
            let size = CGSize(width: listCollectionView.frame.width / 2, height: listCollectionView.frame.width / 2)
            
            
            imageManager.requestImage(for: target, targetSize: size, contentMode: .aspectFit, options: nil) { [weak self] (image, _) in
                guard let image = image else { return }
                let userInfo = ["image": image]
                NotificationCenter.default.post(name: .imageDidSelect, object: nil, userInfo: userInfo)
                self?.dismiss(animated: true, completion: nil)
            }
        }
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
                    guard let self = self else { return }
                    switch selectedStatus {
                    case .authorized, .limited:
                        DispatchQueue.main.async {
                            self.editImageListButton.isEnabled = selectedStatus == .limited
                        }
                    default:
                        break
                        // TODO: 경고창 표시해서 설정으로 이동하게할 것!
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { [weak self] (selectedStatus) in
                    guard let self = self else { return }
                    
                    switch selectedStatus {
                    case .authorized, .limited:
                        DispatchQueue.main.async {
                            self.editImageListButton.isEnabled = false
                        }
                        
                    default:
                        break
                        // TODO: 경고창 표시해서 설정으로 이동하게할 것!
                    }
                }
            }
        case .restricted:
            break
            // TODO: 경고창 표시해서 설정으로 이동하게할 것!
        case .denied:
            break
            // TODO: 경고창 표시해서 설정으로 이동하게할 것!
        case .authorized:
            DispatchQueue.main.async {
                self.editImageListButton.isEnabled = false
            }
        case .limited:
            self.editImageListButton.isEnabled = true
        @unknown default:
            break
            // TODO: 이부분 어떻게 처리할지 확인 할 것!
        }
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAuthorization()
        listCollectionView.allowsMultipleSelection = true
        
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}





extension ImageDisplayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 4,
                      height: collectionView.frame.width / 4)
    }
}





extension ImageDisplayViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            if let changes = changeInstance.changeDetails(for: self.allPhotos) {
                self.allPhotos = changes.fetchResultAfterChanges
                self.listCollectionView.reloadData()
            }
        }
    }
}
