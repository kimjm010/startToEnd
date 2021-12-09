//
//  DiaryListViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit

class DiaryListViewController: UIViewController {
    
    @IBOutlet weak var composeListContainerView: UIStackView!
    
    @IBOutlet weak var composeNormalDiaryButton: UIButton!
    
    @IBOutlet weak var composeRegretDiaryButton: UIButton!
    
    @IBOutlet weak var composeThxDiaryButton: UIButton!
    
    @IBOutlet weak var showComposeMenuButton: UIButton!
    
    @IBOutlet weak var listTableView: UITableView!
    
    /// 화면에 표시한 MyDiary 배열
    var displayedList = [MyDiary]()
    
    var sortedList = [MyDiary]()
    
    var updatedIndexPath: IndexPath?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = listTableView.indexPath(for: cell) {
            updatedIndexPath = indexPath
            if let vc = segue.destination as? DiaryDetailViewController {
                vc.diary = sortedList[indexPath.row]
            }
        }
        
        if let button = sender as? UIButton {
            if let vc = segue.destination.children.first as? DiaryComposeViewController {
                vc.composeTag = button.tag
            }
        }
    }
    
    
    @IBAction func composeDiary(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.composeListContainerView.isHidden = false
        }
    }
    
    @IBAction func moveToComposeScene(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            performSegue(withIdentifier: "composeNormalDiary", sender: sender)
        case 102:
            performSegue(withIdentifier: "composeRegretDiary", sender: sender)
        case 103:
            performSegue(withIdentifier: "composeThxDiary", sender: sender)
        default:
            break
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        
        NotificationCenter.default.addObserver(forName: .didInsertNewDiary, object: nil, queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            guard let newDiary = noti.userInfo?["newDiary"] as? MyDiary else { return }
            
            self.sortedList.insert(newDiary, at: 0)
            
            self.sortedList = self.sortedList.sorted {
                return $0.insertDate > $1.insertDate
            }
            
            self.listTableView.reloadData()
        }
        
        
        NotificationCenter.default.addObserver(forName: .updatedDiaryDidInsert, object: nil, queue: .main) { [weak self] (noti) in
            guard let updatedIndexPath = self?.updatedIndexPath else { return }

            guard let updated = noti.userInfo?["updated"] as? MyDiary else { return }
            
            self?.sortedList[updatedIndexPath.row].content = updated.content
            self?.sortedList[updatedIndexPath.row].insertDate = updated.insertDate
            self?.listTableView.reloadData()
        }
    }
    
    
    /// 필요한 데이터를 초기화합니다.
    func initializeData() {
        
        sortedList = dummyDiaryList.sorted {
            return $0.insertDate > $1.insertDate
        }
        
        composeListContainerView.isHidden = true
        showComposeMenuButton.setTitle("", for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        composeListContainerView.isHidden = true
    }
}




extension DiaryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryListTableViewCell", for: indexPath) as! DiaryListTableViewCell
        
        let target = sortedList[indexPath.row]
        cell.configure(diary: target)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sortedList.remove(at: indexPath.row)
            listTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}




extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
