//
//  ViewController.swift
//  startToEnd
//
//  Created by Chris Kim on 2021/11/27.
//

import UIKit
import DropDown
import CoreData


class ViewController: UIViewController {
    
    @IBOutlet weak var composeContainerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelSelectedCategoryButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelSelectedCalendarButton: UIBarButtonItem!
    
    @IBOutlet weak var selectCalenderButton: UIBarButtonItem!
    
    @IBOutlet weak var selectCategoryButton: UIBarButtonItem!
    
    @IBOutlet weak var toDoListTableView: UITableView!
    
    @IBOutlet weak var composeContainerView: UIView!
    
    @IBOutlet weak var composeTodoButton: UIButton!
    
    @IBOutlet weak var toDoTextField: UITextField!
    
    @IBOutlet weak var dimmingView: UIView!
    
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
    var selectedCategory: TodoCategory?
    
    /// filtering된 요소를 저장할 배열
    var filteredList = [TodoEntity]()
    
    /// 선택된 Todo
    var selectedTodo: TodoEntity?
    
    /// 옵저버 제거를 위해 토큰을 담는 배열
    var tokens = [NSObjectProtocol]()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = toDoListTableView.indexPath(for: cell) {
            if let vc = segue.destination.children.first as? DetailViewController {
                vc.selectedTodo = DataManager.shared.todoList[indexPath.row]
            }
        }
    }
    
    
    @IBAction func showMenu(_ sender: Any) {
        print(#function)
        // TODO: 테이블 뷰 정렬 수동으로 바꿀 수 있게 -> Editing, move
    }
    
    
    @IBAction func cancelSelectedDate(_ sender: Any) {
        cancelSelectedCalendarButton.title = nil
    }
    
    
    @IBAction func showCategory(_ sender: Any) {
        cancelSelectedCategoryButton.title = nil
    }
    
    
    @IBAction func saveTodo(_ sender: Any) {
        
        guard let content = toDoTextField.text, content.count > 0 else {
            alertNoText(title: "알림", message: "오늘의 계획을 입력해주세요 :)", handler: nil)
            return
        }
        
        let newTodo = Todo(content: content,
                           category: selectedCategory ?? TodoCategory(categoryOptions: "\(Category2.duty)"),
                           insertDate: Date(),
                           notiDate: nil,
                           isMarked: false,
                           isCompleted: false,
                           reminder: false,
                           isRepeat: false,
                           memo: nil)
        
        DataManager.shared.createTodo(content: newTodo.content,
                                      category: newTodo.category.categoryOptions,
                                      insertDate: newTodo.insertDate,
                                      notiDate: newTodo.notiDate,
                                      isMarked: newTodo.isMarked,
                                      isCompleted: newTodo.isCompleted,
                                      reminder: newTodo.reminder,
                                      isRepeat: newTodo.isRepeat,
                                      memo: newTodo.memo) {[weak self] in
            let userInfo = ["newTodo": newTodo]
            NotificationCenter.default.post(name: .didInsertNewTodo, object: nil, userInfo: userInfo)
            self?.toDoTextField.text = nil
        }
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
        
        initializeData()
        setupSearchController()
        
        DataManager.shared.fetchTodo()
        toDoListTableView.reloadData()
        
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
        
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                       object: nil,
                                                       queue: .main) { [weak self] (noti) in
            guard let self = self else { return }
            
            self.toDoListTableView.contentInset.bottom = 0
            self.toDoListTableView.verticalScrollIndicatorInsets.bottom = 0
            self.composeContainerViewBottomConstraint.constant = 8
        }
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .setNewDate,
                                                       object: nil,
                                                       queue: .main) { [weak self] (noti) in
            guard let newDate = noti.userInfo?["newDate"] as? Date else {
                return
            }
            
            self?.cancelSelectedCalendarButton.title = newDate.dateToString
        }
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .didInsertNewTodo,
                                                       object: nil,
                                                       queue: .main) { [weak self] _ in
            DataManager.shared.fetchTodo()
            self?.toDoListTableView.reloadData()
        }
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .updatedIsMarked,
                                                       object: nil,
                                                       queue: .main) { [weak self] _ in
            DataManager.shared.fetchTodo()
            self?.toDoListTableView.reloadData()
        }
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .updateToDo,
                                                       object: nil,
                                                       queue: .main) { [weak self] _ in
            DataManager.shared.fetchTodo()
            self?.toDoListTableView.reloadData()
        }
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .selectCategory,
                                                       object: nil,
                                                       queue: .main) { [weak self] (noti) in
            guard let selected = noti.userInfo?["select"] as? TodoCategory else { return }
            self?.cancelSelectedCategoryButton.title = "\(selected.categoryOptions)"
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
        accessoryView.sizeToFit()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredList.count
        }
        
        return DataManager.shared.todoList.count
    }
    
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return IndexPath(row: 0, section: 0)
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
        guard let text = cachedText, !(text.isEmpty || filteredList.isEmpty) else { return }
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
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectedTodo?.content = textField.text
    }
}
