//
//  DiaryListViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/12/08.
//

import UIKit


/// 일기장 목록 화면
class DiaryListViewController: CommonViewController {
    
    /// 일기장 목록 컨테이너 뷰
    @IBOutlet weak var composeListContainerView: UIStackView!
    
    /// 칭찬하기 작성 버튼
    @IBOutlet weak var composeNormalDiaryButton: UIButton!
    
    /// 보완하기 작성 버튼
    @IBOutlet weak var composeRegretDiaryButton: UIButton!
    
    /// 감사하기 작성 버튼
    @IBOutlet weak var composeThxDiaryButton: UIButton!
    
    /// 일기 작성 버튼
    @IBOutlet weak var showComposeMenuButton: UIButton!
    
    /// 일기 표시 테이블 뷰
    @IBOutlet weak var listTableView: UITableView!
    
    /// 디밍 뷰
    ///
    /// 일기 작성 목록이 표시되는 경우 디밍뷰를 표시합니다.
    @IBOutlet weak var dimmingView: UIView!
    
    /// 정렬된 일기 목록
    var sortedList = [MyDiaryEntity]()
    
    /// 일기 목록 표시 여부
    ///
    /// isShow 여부에 따라 dimmingView를 표시 여부가 달라집니다.
    var isShow: Bool = false
    
    
    /// 곧 실행될 뷰 컨트롤러를 준비합니다.
    ///
    /// 새로운 뷰 컨트롤러가 실행되기 전에 설정할 수 있습니다.
    /// - Parameters:
    ///   - segue: 호출된 segue
    ///   - sender: segue가 시작된 객체
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = listTableView.indexPath(for: cell) {
            if let vc = segue.destination as? DiaryDetailViewController {
                vc.diary = DataManager.shared.myDiaryList[indexPath.row]
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
    
    
    /// 해당 일기 작성 화면으로 이동합니다.
    /// - Parameter sender: compose 버튼
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
    /// - Parameter animated: 애니메이션 여부
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dimmingView.alpha = 0.0
        
        sortedList = DataManager.shared.myDiaryList.sorted {
            guard let firstDate = $0.insertDate, let secondDate = $1.insertDate else { return false }
            
            return firstDate > secondDate
        }
        
        listTableView.reloadData()
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
        
        DataManager.shared.fetchDiary()
        listTableView.reloadData()
        
        // 일기를 추가합니다.
        var token = NotificationCenter.default.addObserver(forName: .didInsertNewDiary, object: nil, queue: .main) { [weak self] _ in
            DataManager.shared.fetchDiary()
            self?.listTableView.reloadData()
        }
        tokens.append(token)
 
        
        // 작성된 일기를 업데이트 합니다.
        token = NotificationCenter.default.addObserver(forName: .didUpdateDiary, object: nil, queue: .main) { [weak self] _ in
            DataManager.shared.fetchDiary()
            self?.listTableView.reloadData()
        }
        tokens.append(token)
    }
    
    
    /// 필요한 데이터를 초기화합니다.
    func initializeData() {
        composeListContainerView.isHidden = true
        showComposeMenuButton.setTitle("", for: .normal)
    }
    
    
    /// 뷰가 계층에서 사라지기 전에 호출됩니다.
    /// - Parameter animated: 애니메이션 여부
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        composeListContainerView.isHidden = true
    }
}




extension DiaryListViewController: UITableViewDataSource {
    
    /// 일기의 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 일기 목록 테이블 뷰
    ///   - section: 일기 목록을 나누는 section Index
    /// - Returns: 일기 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.myDiaryList.count
    }
    

    /// 일기 목록 셀을 설정합니다.
    /// - Parameters:
    ///   - tableView: 일기 목록 테이블 뷰
    ///   - indexPath: 일기 목록 셀의 indexPath
    /// - Returns: 일기 목록 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryListTableViewCell", for: indexPath) as! DiaryListTableViewCell
        
        let diary = DataManager.shared.myDiaryList[indexPath.row]
        cell.configure(diary: diary)
        return cell
    }
    
    
    /// 편집스타일이 삭제인경우 일기 목록을 삭제합니다.
    /// - Parameters:
    ///   - tableView: 일기 목록 테이블 뷰
    ///   - editingStyle: 편집 스타일
    ///   - indexPath: 해당 셀의 indexPath
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            let diary = DataManager.shared.myDiaryList.remove(at: indexPath.row)
            DataManager.shared.deleteDiary(entity: diary)
            listTableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}




extension DiaryListViewController: UITableViewDelegate {
    
    /// 일기 목록 셀이 선택되었을 때 동작을 처리합니다.
    ///
    /// 선택 상태를 즉시 해제합니다.
    /// - Parameters:
    ///   - tableView: 일기 목록 테이블 뷰
    ///   - indexPath: 선택된 항목의 indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
