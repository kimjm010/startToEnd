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
    
    @IBOutlet weak var dimmingView: UIView!
    
    /// 화면에 표시한 MyDiary 배열
    var displayedList = [MyDiary]()
    
    var sortedList = [MyDiary]()
    
    var updatedIndexPath: IndexPath?
    
    var isShow: Bool = false
    
    var list = [MyDiaryEntity]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = listTableView.indexPath(for: cell) {
            updatedIndexPath = indexPath
            if let vc = segue.destination as? DiaryDetailViewController {
                vc.diary = list[indexPath.row]
            }
        }
        
        if let button = sender as? UIButton {
            if let vc = segue.destination.children.first as? DiaryComposeViewController {
                vc.composeTag = button.tag
            }
        }
    }
    
    
    /// 일기 작성메뉴를 표시합니다.
    ///
    /// 그날의 분위기에 따라 서로 다른 일기 배경을 표시합니다.
    /// - Parameter sender: showComposeMenu 버튼
    @IBAction func composeDiary(_ sender: Any) {
        isShow = isShow ? false : true
        dimmingView.alpha = isShow ? 0.5 : 0.0
        composeListContainerView.isHidden = isShow ? false : true
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
    
    /// 뷰가 화면에 표시되기 직전에 호출됩니다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dimmingView.alpha = 0.0
        sortedList = dummyDiaryList.sorted {
            return $0.insertDate > $1.insertDate
        }
        
        listTableView.reloadData()
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        
        
        list = DataManager.shared.fetchDiary()
        listTableView.reloadData()
        
        NotificationCenter.default.addObserver(forName: .didInsertNewDiary, object: nil, queue: .main) { [weak self] _ in
            self?.list = DataManager.shared.fetchDiary()
            self?.listTableView.reloadData()
        }
 
        
        NotificationCenter.default.addObserver(forName: .didUpdateDiary, object: nil, queue: .main) { [weak self] _ in
            self?.list = DataManager.shared.fetchDiary()
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
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryListTableViewCell", for: indexPath) as! DiaryListTableViewCell
        
        let diary = list[indexPath.row]
        cell.configure(diary: diary)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            let diary = list.remove(at: indexPath.row)
            DataManager.shared.deleteDiary(entity: diary)
            listTableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}




extension DiaryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
