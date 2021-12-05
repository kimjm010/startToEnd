//
//  ViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/11/27.
//

import UIKit
import DropDown


class ViewController: UIViewController {
    
    @IBOutlet weak var composeToDoContainerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var selectToDoCategoryButton: UIButton!
    
    @IBOutlet weak var selectCalenderButton: UIButton!
    
    @IBOutlet weak var toDoListTableView: UITableView!
    
    @IBOutlet weak var toDoTextField: UITextField!
    
    @IBOutlet weak var composeTabBar: UITabBar!
    
    // searchBar의 상태 확인
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // 필터링 확인 속성
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    // 검색을 관리하는 객체
    let searchController = UISearchController(searchResultsController: nil)
    
    // 화면에 표시할 배열
    var displayedList = [Todo]()
    
    // filtering된 요소를 저장할 배열
    var filteredToDoList = [Todo]()
    
    // 검색문자열을 일시적으로 저장할 속성
    var cachedText: String?
    
    // mark 상태를 저장
    var isMarked: Bool = false
    
    // 완료 상태를 저장
    var isCompleted: Bool = false
    
    var dayCategory: Category.dayOption?
    
    var toDoCategory: Todo.toDoCategory?
    
    var selectedToDo: Todo?
    
    lazy var menu: DropDown? = {
        let menu = DropDown()
        menu.dataSource = [
            Todo.toDoCategory.duty.rawValue,
            Todo.toDoCategory.study.rawValue,
            Todo.toDoCategory.workout.rawValue
        ]
        return menu
    }()
    
    
    // MARK: 더미데이터, 추후에 삭제하고 코어데이터로 업데이트 예정
    var todayList = [
        Todo(content: "오늘, 1번 목록입니다.",
             toDoCategory: .duty,
             isMarked: false,
             insertDate: Date()),
        
        Todo(content: "오늘, 2번 목록입니다.",
             toDoCategory: .study,
             isMarked: false,
             insertDate: Date().addingTimeInterval(-100)),
        
        Todo(content: "오늘, 3번 목록입니다.",
             toDoCategory: .workout,
             isMarked: false,
             insertDate: Date().addingTimeInterval(-200))
    ]
    
    var thisWeekList = [
        Todo(content: "이번 주, 1번 목록입니다.",
             toDoCategory: .duty,
             isMarked: false,
             insertDate: Date().addingTimeInterval(-100)),
        
        Todo(content: "이번 주, 2번 목록입니다.",
             toDoCategory: .study,
             isMarked: false,
             insertDate: Date().addingTimeInterval(-200)),
        
        Todo(content: "이번 주, 3번 목록입니다.",
             toDoCategory: .workout,
             isMarked: false,
             insertDate: Date().addingTimeInterval(-300))
    ]
    
    var thisMonthList = [
        Todo(content: "이번 달, 1번 목록입니다.",
             toDoCategory: .duty,
             isMarked: false,
             insertDate: Date().addingTimeInterval(-300)),
        
        Todo(content: "이번 달, 2번 목록입니다.",
             toDoCategory: .study,
             isMarked: false,
             insertDate: Date().addingTimeInterval(-400)),
        
        Todo(content: "이번 달, 3번 목록입니다.",
             toDoCategory: .workout,
             isMarked: false,
             insertDate: Date().addingTimeInterval(-500))
    ]
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = toDoListTableView.indexPath(for: cell) {
            if let vc = segue.destination.children.first as? DetailViewController {
                vc.selectedTodo = displayedList[indexPath.row]
            }
        }
    }
    
    
    @IBAction func showMenu(_ sender: Any) {
        print(#function)
    }
    
    
    @IBAction func toggleComplete(_ sender: UIButton) {
        print(#function)
    }
    
    
    @IBAction func showCalendar(_ sender: Any) {
        print(#function)
        
        let frame = CGRect(x: 0, y: view.frame.height / 2, width: 100, height: 100)
        let v = UIView(frame: frame)
        view.addSubview(v)
        
        v.backgroundColor = UIColor.systemPink
        
        
    }
    
    
    @IBAction func showToDoCategoryList(_ sender: UIButton) {
        print(#function)
        createView()
//        menu?.show()
//        menu?.anchorView = sender
//        guard let height = menu?.anchorView?.plainView.bounds.height else { return }
//        menu?.bottomOffset = CGPoint(x: 0, y: -height)
//        menu?.width = view.frame.width / 2
//        menu?.backgroundColor = UIColor.systemGray6
//        menu?.textColor = .label
//        menu?.selectionAction = { [weak self] (_, item) in
//
//        }
    }
    
    
    func createView() {
        
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let v = UIView(frame: frame)
        
        view.addSubview(v)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(view.bounds.origin.x + view.frame.width / 2, view.bounds.origin.y + view.frame.height / 2)
        
        displayedList = todayList
        selectCalenderButton.setTitle("", for: .normal)
        selectToDoCategoryButton.setTitle("", for: .normal)
        
        setupSearchController()
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let height = frame.height
                let tabBarHeight = self.composeTabBar.frame.height
                self.composeToDoContainerViewBottomConstraint.constant = height - tabBarHeight
            }
        }
        
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            
            self.composeToDoContainerViewBottomConstraint.constant = 0
        }
        
    
        NotificationCenter.default.addObserver(forName: .updateToDo, object: nil, queue: .main) { [weak self] (noti) in
            guard let newToDo = noti.userInfo?["updated"] as? Todo else { return }
            
            print(newToDo.content, newToDo.isMarked, newToDo.toDoCategory.rawValue)
            self?.toDoListTableView.reloadData()
        }
    
    
    }
    
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "지난 계획을 검색하세요 :)"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        filteredToDoList = displayedList.filter { (todo) -> Bool in
            return todo.content.lowercased().contains(searchText.lowercased())
        }
        
        toDoListTableView.reloadData()
    }
}




extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredToDoList.count
        }
        return displayedList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell",
                                                 for: indexPath) as! ListTableViewCell
        
        var target: Todo
        
        if isFiltering {
            target = filteredToDoList[indexPath.row]
        } else {
            target = displayedList[indexPath.row]
        }
        cell.configure(todo: target)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            displayedList.remove(at: indexPath.row)
            toDoListTableView.deleteRows(at: [indexPath], with: .automatic)
            toDoListTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}




extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoListTableView.deselectRow(at: indexPath, animated: true)
    }
}




extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryListCollectionViewCell",
                                                      for: indexPath) as! CategoryListCollectionViewCell
        
        let target = categoryList[indexPath.row]
        cell.configure(category: target)
        return cell
    }
}




extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, indexPath.item)
        switch indexPath.item {
        case 0:
            displayedList = todayList
        case 1:
            displayedList = thisWeekList
        case 2:
            displayedList = thisMonthList
        default:
            displayedList = todayList
        }
        
        toDoListTableView.reloadData()
    }
}




extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let bounds = collectionView.bounds
        
        var height = bounds.height - (layout.sectionInset.bottom + layout.sectionInset.top)
        var width = bounds.width - (layout.sectionInset.right + layout.sectionInset.left)
        
        switch layout.scrollDirection {
        case .horizontal:
            height = 50
            width = (width - (layout.minimumInteritemSpacing * 2)) / 3
        default:
            break
        }
        
        return CGSize(width: width, height: height)
    }
}




extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else { return }
        
        filterContentForSearchText(text)
    }
}




extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
        cachedText = searchText
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = cachedText, !(text.isEmpty || filteredToDoList.isEmpty) else { return }
        searchController.searchBar.text = text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = true
    }
}




extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == toDoTextField {
            guard let content = textField.text, content.count > 0 else {
                alertNoText(title: "알림", message: "오늘의 계획을 입력하지 않으셨군요!", handler: nil)
                return false
            }
            
            // TODO: Category 정할 수 있게 하기!
            let newToDo = Todo(content: content, toDoCategory: .workout, isMarked: false, insertDate: Date())
            displayedList.insert(newToDo, at: 0)
            toDoListTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        toDoTextField.text = nil

        return true
    }
}
