//
//  CreateCheckListViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 27/04/2021.
//

import UIKit

var subCategoryList = [SubCategoryViewModel]()

class SubCategoryListViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var catNameLbl: UILabel!
    @IBOutlet weak var subCatTV: UITableView!
    
    //MARK: - OBJECT AND VERIBALES
    var categoryDetailObject = CategoryViewModel()
    var indexToAdit = -1
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAuthObserver()
        
        catNameLbl.text = self.categoryDetailObject.name
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subCatTV.reloadData()

        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Create_Check_List)
        }
    }
    
    //MARK: - FUNCTIONS
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func moveToAddTaskVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CreateNewTaskViewController) as! CreateNewTaskViewController
        vc.indexToAdit = indexToAdit
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - IBAtion
    
    @IBAction func addTaskAction(_ sender: Any) {
        moveToAddTaskVC()
    }
    
    @IBAction func submitCategoryAction(_ sender: Any) {
        let catViewModel = CategoryViewModel()
        catViewModel.subCategoryList = subCategoryList
        categoryDetailObject.subCategoryList = subCategoryList
        print("Category ID: ",categoryDetailObject.id)
        
        let paramsDic = categoryDetailObject.getParams()  //catViewModel.getParams()
        print(paramsDic)
        submitCategoryApi(params: paramsDic)
    }
}
//MARK: - EXTENSION TABEL VIEW METHODS
extension SubCategoryListViewController: UITableViewDelegate, UITableViewDataSource, SubCategoryListTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        if subCategoryList.count > 0{
            return subCategoryList.count
        }else{
            self.showAlertView(message: "No subcategory list found")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SubCategoryListTableViewCell) as! SubCategoryListTableViewCell
        
        cell.configureSubCategory(info: subCategoryList[indexPath.row])
        cell.delegate = self
        cell.viewShadow.dropShadow(radius: 5, opacity: 0.4)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "", handler: {a,b,c in
            //delete Action here
            self.showAlertView(message: PopupMessages.Sure_To_Delete_Task, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
                
                subCategoryList.remove(at: indexPath.row)
                tableView.reloadData()
            }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
                
            }
        })
        
        deleteAction.image = UIImage(named: "delete_icon_white.png")
        deleteAction.backgroundColor = .red
        
        
        let aditAction = UIContextualAction(style: .normal, title: "", handler: {a,b,c in
            //Adit Action here
            self.indexToAdit = indexPath.row
            self.moveToAddTaskVC()
            
        })
        
        aditAction.image = UIImage(named: "edit-icon.png")
        aditAction.backgroundColor = .white
        
        return UISwipeActionsConfiguration(actions: [deleteAction,aditAction])
        
    }
    
    //MARK: - DELEGATE METHODS
    func callBackActionMarkPriority(index: Int) {
        print(index)
    }
    func callBackActionNotAvailable(index: Int) {
        print(index)
    }
}

//MARK: - Server calls
extension SubCategoryListViewController {
    func submitCategoryApi(params:ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            StoreCategoryService.shared().submitSubcategoryApi(params: params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success{
//                        if let category = catInfo{
//                            self.categoryObject = category
//                            self.viewTabel.reloadData()
                        
                        //}
                        self.showAlertView(message: message, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}
