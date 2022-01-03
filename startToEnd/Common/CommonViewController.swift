//
//  CommonViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2022/01/01.
//

import UIKit


class CommonViewController: UIViewController {
    
    /// 옵저버 제거를 위해 토큰을 담는 배열
    var tokens = [NSObjectProtocol]()
    
    
    /// 소멸자에서 옵저버를 제거
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
}
