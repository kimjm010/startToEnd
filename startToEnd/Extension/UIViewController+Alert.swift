//
//  UIViewController+Alert.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/01.
//

import UIKit


extension  UIViewController {
    
    /// 입력된 toDoList가 없는 경우 알림 표시
    /// - Parameters:
    ///   - title:알림의 title
    ///   - message: 알림의 message
    ///   - handler: 알림 이후의 동작
    func alertNoText(title: String, message: String, handler: ((UIAlertAction) -> Void
    )? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// 앨범 접근 권한에 따른 알림을 표시합니다.
    /// - Parameters:
    ///   - title: 알림의 title
    ///   - message: 알림의 message
    ///   - handler: goToSettingAction 클릭 이후의 동작
    func alertAccessPhotoLibrary(title: String? = "\"StartToEnd\" Woul Like to Access Your Photos",
                                 message: String? = "This app requires access to photo library",
                                 handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let laterAction = UIAlertAction(title: "Don't Allow", style: .cancel, handler: nil)
        alert.addAction(laterAction)
        
        let goToSettingAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(goToSettingAction)
        
        present(alert, animated: true, completion: nil)
    }
}
