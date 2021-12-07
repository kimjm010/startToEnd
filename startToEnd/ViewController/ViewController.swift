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
    
    @IBOutlet weak var cancelSelectedCategoryButton: UIButton!
    
    @IBOutlet weak var selectToDoCategoryButton: UIButton!
    
    @IBOutlet weak var selectCalenderButton: UIButton!
    
    @IBOutlet weak var toDoListTableView: UITableView!
    
    @IBOutlet weak var toDoTextField: UITextField!
    
    @IBOutlet weak var composeTabBar: UITabBar!
    
    @IBOutlet weak var composeContainerView: UIView!
    
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
    var selectedCategory: Category2?
    
    /// 화면에 표시할 배열
    var displayedList = [Todo1]()
    
    /// filtering된 요소를 저장할 배열
    var filteredList = [Todo1]()
    
    /// 선택된 ToDo 항목
    var selectedToDo: Todo1?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = toDoListTableView.indexPath(for: cell) {
            if let vc = segue.destination.children.first as? DetailViewController {
                vc.reallySelectedTodo = displayedList[indexPath.row]
                vc.selectedCategoryRawvalue = displayedList[indexPath.row].category.categoryName
            }
        }
    }
    
    
    @IBAction func showMenu(_ sender: Any) {
        print(#function)
        // TODO: 테이블 뷰 정렬 수동으로 바꿀 수 있게 -> Editing, move
    }
    
    
    @IBAction func toggleComplete(_ sender: UIButton) {
        print(#function)
    }
    
    
    @IBAction func showCalendar(_ sender: Any) {
        print(#function)
        // TODO: Calendar view 그려서 표시하기
    }
    
    
    @IBAction func cancelSelectedCategory(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            // TODO: Animation 자연스럽게 없애기
            self.cancelSelectedCategoryButton.isHidden = true
            self.selectToDoCategoryButton.isHidden = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeData()
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
            //guard let newToDo = noti.userInfo?["updated"] as? Todo else { return }
            guard let newToDo = noti.userInfo?["updated"] as? Todo1 else { return }
            
            print(newToDo.content, newToDo.isMarked, newToDo.category.categoryName)
            self?.toDoListTableView.reloadData()
        }
        
        
        NotificationCenter.default.addObserver(forName: .selectCategory, object: nil, queue: .main) { [weak self] (noti) in
            guard let selectedCategory = noti.userInfo?["select"] as? Category2 else { return }
            self?.cancelSelectedCategoryButton.isHidden = false
            self?.selectToDoCategoryButton.isHidden = true
            self?.cancelSelectedCategoryButton.setTitle("\(selectedCategory)", for: .normal)
            self?.selectedCategory = selectedCategory
        }
    }
    
    
    /// 데이터를 초기화합니다.
    func initializeData() {
        displayedList = dummyToDoList
        cancelSelectedCategoryButton.isHidden = true
        composeContainerView.layer.cornerRadius = 14
        selectCalenderButton.setTitle("", for: .normal)
        selectToDoCategoryButton.setTitle("", for: .normal)
        cancelSelectedCategoryButton.setTitle("", for: .normal)
    }
    
    
    /// searchController를 초기화 합니다.
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "지난 계획을 검색하세요 :)"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        selectToDoCategoryButton.configureStyle(with: [.pillShape])
    }
    
    
    /// 검색어를 통해 필터링합니다.
    /// - Parameter searchText: 입력된 검색어
    func filterContentForSearchText(_ searchText: String) {
        filteredList = displayedList.filter { (todo) -> Bool in
            return todo.content.lowercased().contains(searchText.lowercased())
        }
        
        toDoListTableView.reloadData()
    }
}




extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredList.count
        }
        
        return displayedList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell",
                                                 for: indexPath) as! ListTableViewCell
        
        var reallyTarget: Todo1
        
        if isFiltering {
            reallyTarget = filteredList[indexPath.row]
        } else {
            reallyTarget = displayedList[indexPath.row]
        }
        
        cell.reallyConfigure(todo1: reallyTarget)
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
    
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return IndexPath(row: 0, section: 0)
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
        
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = UIColor.systemGray5
        }
        return cell
    }
}




extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, indexPath.item)
        switch indexPath.item {
        default:
            displayedList
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
            width = (width - (layout.minimumLineSpacing * 2)) / 3
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == toDoTextField {
            guard let content = textField.text, content.count > 0 else {
                alertNoText(title: "알림", message: "오늘의 계획을 입력해주세요 :)", handler: nil)
                return false
            }
            
            guard let selectedCategory = selectedCategory else { return false }
            
            // TODO: Category Forced Unwrapping을 벗겨내야해
            let newToDo = Todo1(content: content, insertDate: Date(), category: Category1(categoryName: selectedCategory), isMarked: false, isCompleted: false)
            
            displayedList.insert(newToDo, at: 0)
            toDoListTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        
        toDoTextField.text = nil
        selectedCategory = nil
        cancelSelectedCategoryButton.isHidden = true
        selectToDoCategoryButton.isHidden = false
        
        return true
    }
}
