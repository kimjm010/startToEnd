//
//  SelectCategoryViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/03.
//

import UIKit


class SelectCategoryViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    var categoryList = Category2.allCases
    
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(forName: .newCategoryDidInsert, object: nil, queue: .main) { [weak self] (noti) in
            guard let newCategory = noti.userInfo?["newCategory"] as? String else { return }
            
            #if DEBUG
            print(newCategory)
            #endif
            
            // TODO: 왜 자꾸 Category2인스턴스를 만들면 nil이 되는 걸까
            guard let count = self?.categoryList.count else { return }
            let insertCategory = Category2.init(rawValue: count + 1)
            // 여기서 자꾸 Optional Category2인스턴스가 만들어지네
            self?.categoryList.append(insertCategory ?? .duty)
            self?.listTableView.reloadData()
        }
    }
}





extension SelectCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryTableViewCell", for: indexPath) as! SelectCategoryTableViewCell
        
        let target = categoryList[indexPath.row]
        cell.configure(category: target)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            categoryList.remove(at: indexPath.row)
            listTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}




extension SelectCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function, "%%%%%%%%")
        
        let category = categoryList[indexPath.row]
        let userInfo = ["select": category]
        NotificationCenter.default.post(name: .selectCategory, object: nil, userInfo: userInfo)
        dismiss(animated: true, completion: nil)
    }
}



