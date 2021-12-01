//
//  ViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/11/27.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var toDoListTableView: UITableView!
    
    @IBOutlet weak var toDoTextField: UITextField!
    
    @IBOutlet weak var composeToDoContainerViewBottomConstraint: NSLayoutConstraint!
    
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
    
    
    
    // MARK: 더미데이터, 추후에 삭제하고 코어데이터로 업데이트 예정
    var todayList = [
        Todo(content: "오늘, 1번 목록입니다.", toDoCategory: .duty, isHighlighted: false),
        Todo(content: "오늘, 2번 목록입니다.", toDoCategory: .study, isHighlighted: false),
        Todo(content: "오늘, 3번 목록입니다.", toDoCategory: .workout, isHighlighted: false)
    ]
    
    var thisWeekList = [
        Todo(content: "이번 주, 1번 목록입니다.", toDoCategory: .duty, isHighlighted: false),
        Todo(content: "이번 주, 2번 목록입니다.", toDoCategory: .study, isHighlighted: false),
        Todo(content: "이번 주, 3번 목록입니다.", toDoCategory: .workout, isHighlighted: false)
    ]
    
    var thisMonthList = [
        Todo(content: "이번 달, 1번 목록입니다.", toDoCategory: .duty, isHighlighted: false),
        Todo(content: "이번 달, 2번 목록입니다.", toDoCategory: .study, isHighlighted: false),
        Todo(content: "이번 달, 3번 목록입니다.", toDoCategory: .workout, isHighlighted: false)
    ]
    
    let categoryList = [
        Category(dayCategory: "Today"),
        Category(dayCategory: "ThisWeek"),
        Category(dayCategory: "ThisMonth")
    ]
    
    
    
    
    @IBAction func showMenu(_ sender: Any) {
        print(#function)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayedList = todayList
        toDoTextField.becomeFirstResponder()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        
        var target: Todo
        
        if isFiltering {
            target = filteredToDoList[indexPath.row]
        } else {
            target = displayedList[indexPath.row]
        }
        cell.configure(todo: target)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(#function, indexPath.row, indexPath.section)
        }
    }
}




extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function, indexPath.section, indexPath.row)
        toDoListTableView.deselectRow(at: indexPath, animated: true)
    }
}




extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryListCollectionViewCell", for: indexPath) as! CategoryListCollectionViewCell
        
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == toDoTextField {
            guard let content = textField.text, content.count > 0 else {
                alertNoText(title: "알림", message: "오늘의 계획을 입력하지 않으셨군요!", handler: nil)
                return false
            }
            
            // TODO: Category 정할 수 있게 하기!
            let newToDo = Todo(content: content, toDoCategory: .workout, isHighlighted: false)
            displayedList.insert(newToDo, at: 0)
            toDoListTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        toDoTextField.text = nil

        return true
    }
}
