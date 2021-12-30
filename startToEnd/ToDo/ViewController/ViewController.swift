//
//  ViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/11/27.
//

import UIKit
import DropDown
import CoreData


/// todo 목록 화면
class ViewController: UIViewController {
    
    /// todo 작성 컨테이너 뷰 bottom 제약
    @IBOutlet weak var composeContainerViewBottomConstraint: NSLayoutConstraint!
    
    /// 카테고리 버튼
    ///
    /// 클릭 시 선택한 카테고리가 취소됩니다.
    @IBOutlet weak var cancelSelectedCategoryButton: UIBarButtonItem!
    
    /// 날짜 버튼
    ///
    /// 클릭 시 선택한 날짜가 취소됩니다.
    @IBOutlet weak var cancelSelectedCalendarButton: UIBarButtonItem!
    
    /// 날짜를 선택 버튼
    ///
    /// 기본값을 현재 날짜 입니다.
    @IBOutlet weak var selectCalenderButton: UIBarButtonItem!
    
    /// todo 카테고리를 선택 버튼
    @IBOutlet weak var selectCategoryButton: UIBarButtonItem!
    
    /// todo 목록 테이블 뷰
    @IBOutlet weak var toDoListTableView: UITableView!
    
    /// todo 작성 컨테이버 뷰
    @IBOutlet weak var composeContainerView: UIView!
    
    /// todo 저장 버튼
    @IBOutlet weak var composeTodoButton: UIButton!
    
    /// todo 텍스트 필드
    ///
    /// 오늘 할 일을 작성합니다.
    @IBOutlet weak var toDoTextField: UITextField!
    
    /// 날짜 및 카테고리 선택 버튼을 포함한 툴바
    @IBOutlet var accessoryView: UIToolbar!
    
    /// searchBar의 상태 확인
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// 필터링 확인 속성
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    /// 검색을 관리하는 객체
    let searchController = UISearchController(searchResultsController: nil)
    
    /// 검색문자열을 일시적으로 저장할 속성
    var cachedText: String?
    
    /// mark 상태 저장 속성
    var isMarked: Bool = false
    
    /// 완료 상태 저장 속성
    var isCompleted: Bool = false
    
    /// category 저장 속성
    var selectedCategory: TodoCategoryEntity?
    
    /// filtering된 요소를 저장할 배열
    var filteredList = [TodoEntity]()
    
    /// 선택된 Todo
    var selectedTodo: TodoEntity?
    
    /// 옵저버 제거를 위해 토큰을 담는 배열
    var tokens = [NSObjectProtocol]()
    
    
    /// 곧 실행될 뷰 컨트롤러를 준비합니다.
    ///
    /// 새로운 뷰 컨트롤러가 실행되기 전에 설정할 수 있습니다.
    /// - Parameters:
    ///   - segue: 호출된 segue
    ///   - sender: segue가 시작된 객체
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = toDoListTableView.indexPath(for: cell) {
            if let vc = segue.destination.children.first as? DetailViewController {
                vc.selectedTodo = DataManager.shared.todoList[indexPath.row]
            }
        }
    }
    
    
    /// 메뉴를 표시합니다.
    ///
    /// todo를 수동으로 정렬할 수 있습니다.
    /// - Parameter sender: 메뉴 버튼
    @IBAction func showMenu(_ sender: Any) {
        print(#function)
        // TODO: 테이블 뷰 정렬 수동으로 바꿀 수 있게 -> Editing, move
    }
    
    
    /// 선택한 날짜를 취소합니다.
    /// - Parameter sender: 날짜 버튼
    @IBAction func cancelSelectedDate(_ sender: Any) {
        cancelSelectedCalendarButton.title = nil
    }
    
    
    /// 카테고리를 선택합니다.
    /// - Parameter sender: 카테고리 버튼
    @IBAction func showCategory(_ sender: Any) {
        cancelSelectedCategoryButton.title = nil
    }
    
    
    @IBAction func dismissKeyboardNotification(_ sender: Any) {
        willHideKeyboard()
    }
    
    
    /// todo를 저장합니다.
    /// - Parameter sender: 입력 버튼
    @IBAction func saveTodo(_ sender: Any) {
        
        guard let content = toDoTextField.text, content.count > 0 else {
            alertNoText(title: "알림", message: "오늘의 계획을 입력해주세요 :)", handler: nil)
            return
        }
        
        guard let category = selectedCategory?.category else { return }
        DataManager.shared.createTodo(content: content,
                                      category: category,
                                      insertDate: Date(),
                                      notiDate: nil,
                                      isMarked: false,
                                      isCompleted: false,
                                      reminder: false,
                                      isRepeat: false,
                                      memo: nil) {
            NotificationCenter.default.post(name: .didInsertNewTodo, object: nil)
            self.toDoTextField.text = nil
            self.cancelSelectedCategoryButton.title = nil
        }
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.fetchTodo()
        toDoListTableView.reloadData()
        
        initializeData()
        setupSearchController()
        
        willHideKeyboard()
        
        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                           object: nil,
                                                           queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = self.toDoListTableView.contentInset
                inset.bottom = height
                self.toDoListTableView.contentInset = inset
                
                inset = self.toDoListTableView.verticalScrollIndicatorInsets
                inset.bottom = height
                self.toDoListTableView.verticalScrollIndicatorInsets = inset
                
                guard let tabBarHeight = self.tabBarController?.tabBar.frame.height else { return }
                self.composeContainerViewBottomConstraint.constant = height - tabBarHeight
            }
        }
        tokens.append(token)
        
        
        // 선택한 날짜를 표시합니다.
        token = NotificationCenter.default.addObserver(forName: .setNewDate,
                                                       object: nil,
                                                       queue: .main) { [weak self] (noti) in
            guard let newDate = noti.userInfo?["newDate"] as? Date else {
                return
            }
            
            self?.cancelSelectedCalendarButton.title = newDate.dateToString
        }
        tokens.append(token)
        
        
        // todo를 추가합니다.
        token = NotificationCenter.default.addObserver(forName: .didInsertNewTodo,
                                                       object: nil,
                                                       queue: .main) { [weak self] _ in
            DataManager.shared.fetchTodo()
            self?.toDoListTableView.reloadData()
        }
        tokens.append(token)
        
        
        // 업데이트된 todo를 화면에 표시합니다.
        token = NotificationCenter.default.addObserver(forName: .updateToDo,
                                                       object: nil,
                                                       queue: .main) { [weak self] (noti) in
            guard let updated = noti.userInfo?["updated"] as? Bool else { return }
            self?.isMarked = updated
            DataManager.shared.fetchTodo()
            self?.toDoListTableView.reloadData()
        }
        tokens.append(token)
        
        
        // 선택한 카테고리를 표시합니다.
        token = NotificationCenter.default.addObserver(forName: .selectCategory,
                                                       object: nil,
                                                       queue: .main) { [weak self] (noti) in
            guard let selected = noti.userInfo?["select"] as? TodoCategoryEntity,
                  let category = selected.category else { return }
            self?.cancelSelectedCategoryButton.title = category
            self?.selectedCategory = selected
        }
        tokens.append(token)
    }
    
    /// 소멸자에서 옵저버를 제거
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    /// 데이터를 초기화합니다.
    func initializeData() {
        composeContainerView.applyBigRoundedRect()
        toDoTextField.inputAccessoryView = accessoryView
        composeTodoButton.setTitle("", for: .normal)
        cancelSelectedCalendarButton.title = "\(Date().dateToString)"
        cancelSelectedCategoryButton.title = nil
    }
    
    
    /// searchController를 초기화 합니다.
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "지난 계획을 검색하세요 :)"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    /// keyboardWillHide 노티피케이션을 실행합니다.
    func willHideKeyboard() {
        let token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                       object: nil,
                                                       queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            
            self.toDoListTableView.contentInset.bottom = 0
            self.toDoListTableView.verticalScrollIndicatorInsets.bottom = 0
            self.composeContainerViewBottomConstraint.constant = 8
        }
        tokens.append(token)
    }
    
    
    /// 검색어를 통해 필터링합니다.
    /// - Parameter searchText: 입력된 검색어
    func filterContentForSearchText(_ searchText: String) {
        filteredList = DataManager.shared.todoList.filter { (todo) -> Bool in
            return todo.content?.lowercased().contains(searchText.lowercased()) ?? false
        }
        
        toDoListTableView.reloadData()
    }
}




extension ViewController: UITableViewDataSource {
    
    /// todo 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: toDoListTableView
    ///   - section: todo 목록을 나누는 section Index
    /// - Returns: todo 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredList.count
        }
        
        return DataManager.shared.todoList.count
    }
    
    
    /// todo 목록 셀을 설정합니다.
    /// - Parameters:
    ///   - tableView: toDoListTableView
    ///   - indexPath: todo셀의 indexPath
    /// - Returns: todo 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell",
                                                 for: indexPath) as! ListTableViewCell
        
        var target: TodoEntity
        
        if isFiltering {
            target = filteredList[indexPath.row]
        } else {
            target = DataManager.shared.todoList[indexPath.row]
        }
        
        cell.configure(todo: target)
        return cell
    }
    
    
    /// 편집스타일에 따라 다른 동작을 실행합니다.
    /// - Parameters:
    ///   - tableView: toDoListTableView
    ///   - editingStyle: 편집 스타일
    ///   - indexPath: 해당 셀의 indexPath
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = DataManager.shared.todoList.remove(at: indexPath.row)
            DataManager.shared.deleteTodo(entity: todo)
            toDoListTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}




extension ViewController: UITableViewDelegate {
    
    /// todo 목록 셀이 선택되었을 때 동작을 처리합니다.
    /// - Parameters:
    ///   - tableView: toDoListTableView
    ///   - indexPath: 선택된 셀의 indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoListTableView.deselectRow(at: indexPath, animated: true)
        print(#function, "^^", DataManager.shared.todoList[indexPath.row])
    }
    
    
    /// todo 목록 셀의 순서를 바꿉니다.
    /// - Parameters:
    ///   - tableView: toDoListTableView
    ///   - sourceIndexPath: 선택된 셀의 indexPath
    ///   - proposedDestinationIndexPath: 선택된 셀이 이동할 indexPath
    /// - Returns: IndexPath
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return IndexPath(row: 0, section: 0)
    }
    
    
    /// todo셀을 구성하기 전에 호출됩니다.
    /// - Parameters:
    ///   - tableView: toDoListTableView
    ///   - cell: todo 셀
    ///   - indexPath: todo 셀의 indexPath
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(#function, "&&")
        let target = DataManager.shared.todoList[indexPath.row]
        guard let cell = cell as? ListTableViewCell else { return }
        
        cell.isMarkedImageView.isHighlighted = target.isMarked
    }
    
    
    /// 셀이 구성된 이후에 호출됩니다.
    /// - Parameters:
    ///   - tableView: toDoListTableView
    ///   - cell: todo 셀
    ///   - indexPath: todo셀의 indexPath
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(#function, "**")
    }
    
}




extension ViewController: UISearchResultsUpdating {
    
    /// 서치바의 내용이 변경되는 경우 호출됩니다.
    /// - Parameter searchController: 서치컨트롤러 객체
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else { return }
        
        filterContentForSearchText(text)
    }
}




extension ViewController: UISearchBarDelegate {
    
    /// 검색내용이 변경될 때마다 호출됩니다.
    /// - Parameters:
    ///   - searchBar: 편집중인 서치 바
    ///   - searchText: search textField의 현재 text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
        cachedText = searchText
    }
    
    
    /// 검색 내용 편집이 끝났을 시에 호출됩니다.
    /// - Parameter searchBar: 편집중인 서치 바
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = cachedText, !(text.isEmpty || filteredList.isEmpty) else { return }
        searchController.searchBar.text = text
    }
    
    /// 검색버튼 혹은 return 버튼을 눌렀을 시에 호출됩니다.
    /// - Parameter searchBar: 편집중인 서치 바
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = true
    }
}




extension ViewController: UITextFieldDelegate {
    
    /// 텍스트 필드 편집 중 placeholder상태를 관리합니다.
    ///
    /// 편집 중 placeholder를 숨깁니다.
    /// - Parameter textField: toDoTextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    
    /// 텍스트 필드 편집 후 placeholder상태를 관리합니다.
    ///
    /// 텍스트가 없는 경우 placeholder를 다시 표시합니다.
    /// - Parameter textField: toDoTextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectedTodo?.content = textField.text
    }
}
