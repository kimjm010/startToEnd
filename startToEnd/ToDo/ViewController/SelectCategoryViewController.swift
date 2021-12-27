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

    
    
    /// Category선택 화면을 닫습니다.
    /// - Parameter sender: Cancel버튼
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.fetchCategory()
        listTableView.reloadData()
        
        // 새로운 Category를 추가합니다.
        let token = NotificationCenter.default.addObserver(forName: .newCategoryDidInsert, object: nil, queue: .main) { [weak self] _ in
            DataManager.shared.fetchCategory()
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
        return DataManager.shared.categoryList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryTableViewCell", for: indexPath) as! SelectCategoryTableViewCell
        
        let target = DataManager.shared.categoryList[indexPath.row]
        cell.configure(category: target)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = DataManager.shared.categoryList.remove(at: indexPath.row)
            DataManager.shared.deleteCategory(entity: category)
            listTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}




extension SelectCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = DataManager.shared.categoryList[indexPath.row]
        let userInfo = ["select": category]
        NotificationCenter.default.post(name: .selectCategory, object: nil, userInfo: userInfo)
        dismiss(animated: true, completion: nil)
    }
}



