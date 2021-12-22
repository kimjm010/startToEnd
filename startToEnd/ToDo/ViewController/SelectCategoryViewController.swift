//
//  SelectCategoryViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/03.
//

import UIKit


/// Category선택 화면
class SelectCategoryViewController: UIViewController {

    /// Category 표시 테이블 뷰
    @IBOutlet weak var listTableView: UITableView!
    
    /// 옵저버 제거를 위해 토큰을 담는 배열
    var tokens = [NSObjectProtocol]()
    
    /// TodoCategory 배열
    ///
    /// 기본적으로 3개의 속성이 선언되어 있습니다.
    var list = [
        TodoCategory(categoryOptions: "\(Category2.duty)"),
        TodoCategory(categoryOptions: "\(Category2.workout)"),
        TodoCategory(categoryOptions: "\(Category2.study)")
    ]
    
    
    /// Category선택 화면을 닫습니다.
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 새로운 Category를 추가합니다.
        let token = NotificationCenter.default.addObserver(forName: .newCategoryDidInsert, object: nil, queue: .main) { [weak self] (noti) in
            guard let newCategory = noti.userInfo?["newCategory"] as? String else { return }
            self?.list.append(TodoCategory(categoryOptions: newCategory))
            self?.listTableView.reloadData()
        }
        tokens.append(token)
        
    }
    
    /// 소멸자에서 옵저버를 제거합니다.
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
}




extension SelectCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryTableViewCell", for: indexPath) as! SelectCategoryTableViewCell
        
        let target = list[indexPath.row]
        cell.configure(category: target.categoryOptions)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            listTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}




extension SelectCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = list[indexPath.row]
        let userInfo = ["select": category]
        NotificationCenter.default.post(name: .selectCategory, object: nil, userInfo: userInfo)
        dismiss(animated: true, completion: nil)
    }
}



