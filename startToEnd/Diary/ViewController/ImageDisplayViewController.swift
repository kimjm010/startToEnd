//
//  ImageDisplayViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/09.
//

import UIKit
import Photos


extension NSNotification.Name {
    static let imageDidSelect = Notification.Name(rawValue: "imageDidSelect")
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
    
    var imageList = [UIImage]()
    
    
    @IBAction func editSelectedImageList(_ sender: Any) {
        if #available(iOS 14, *) {
            //PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
        }
    }
    
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectAttachedImages(_ sender: Any) {
        guard let indexPath = listCollectionView.indexPathsForSelectedItems else { return }
        
        for index in indexPath {
            let target = allPhotos.object(at: index.item)
            let size = CGSize(width: listCollectionView.frame.width / 2, height: listCollectionView.frame.width / 2)
            
            imageManager.requestImage(for: target, targetSize: size, contentMode: .aspectFill, options: nil) { [weak self] (image, _) in
                if let image = image {
                    let userInfo = ["image": image]
                    NotificationCenter.default.post(name: .imageDidSelect, object: nil, userInfo: userInfo)
                    print(image.description)
                    self?.dismiss(animated: true, completion: nil)
                }
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
        let size = CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.width / 2)
        
        imageManager.requestImage(for: target, targetSize: size, contentMode: .aspectFill, options: nil) { (image, _) in
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




extension ImageDisplayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        else {
//            let actualIndex = hasLimitedPermission ? indexPath.item - 1 : indexPath.item
//            let target = allPhotos.object(at: actualIndex)
//            let size = CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.width / 2)
//
//            imageManager.requestImage(for: target, targetSize: size, contentMode: .aspectFill, options: nil) { [weak self] (image, _) in
//                let userInfo = ["image": image]
//                NotificationCenter.default.post(name: .imageDidSelect, object: nil, userInfo: userInfo)
//                self?.dismiss(animated: true, completion: nil)
//            }
//        }
    }
}



extension ImageDisplayViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            guard let changes = changeInstance.changeDetails(for: self.allPhotos) else { return }
            self.allPhotos = changes.fetchResultAfterChanges
            self.listCollectionView.reloadData()
        }
    }
}
