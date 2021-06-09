//
//  CategoryViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/04/2021.
//

import UIKit

class CategoryListViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewTabel: UITableView!
    
    
    //MARK: - OBJECT AND VERIBAELS
    var categoryObject = CategoryListViewModel()
    
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAuthObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.CheckList)
        }
        self.getCategoryListApi()
    }
    
    //MARK: - ACTION METHODS
    @IBAction func actionCreateCategory(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CreateCategoryViewController) as! CreateCategoryViewController
        vc.categoryObj = self.categoryObject
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //MARK: - FUNCTIONS
    func moveToAddCategoryVC(isForEdit: Bool, catObject: CategoryViewModel?) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.AddCategoryViewController) as! AddCategoryViewController
        vc.isForUpdate = isForEdit
        vc.categoryObj = catObject
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func actionBack() {
        self.loadHomeController()
        //self.navigationController?.popViewController(animated: true)
    }
    
    
}
//MARK: - EXTENSION TABEL VIEW METHODS
extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource, CategoryListTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryObject.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CategoryListTableViewCell) as! CategoryListTableViewCell
        cell.configureCategory(info: self.categoryObject.categoryList[indexPath.row], index: indexPath.row)
        cell.viewShadow.dropShadow(radius: 5, opacity: 0.4)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.SubCategoryListViewController) as! SubCategoryListViewController
        vc.subCategoryList = self.categoryObject.categoryList[indexPath.row].subCategoryList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    //MARK: - CategoryListTableViewCell DELEGATE METHODS
    func callBackActionDeleteCategory(index: Int) {
        self.showAlertView(message: PopupMessages.Sure_To_Delete_Category, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
            
            let catID = self.categoryObject.categoryList[index].id
            self.deleteCategoryListApi(param: [DictKeys.Category_Id: catID])
            
        }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
            
        }
    }
    
    func callBackActionEditCategory(index: Int) {
        let catID = self.categoryObject.categoryList[index].id
        let catObject = self.categoryObject.getCategoryDetailAganistID(CategoryID: catID)
        self.moveToAddCategoryVC(isForEdit: true, catObject: catObject)
    }
    
}

//MARK: - EXTENSION API CALLS
extension CategoryListViewController{
    func getCategoryListApi(){
        self.startActivity()
        GCD.async(.Background) {
            StoreCategoryService.shared().categoryListApi(params: [:]) { (message, success, catInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success{
                        if let category = catInfo{
                            self.categoryObject = category
                            self.viewTabel.reloadData()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    func deleteCategoryListApi(param: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            StoreCategoryService.shared().deleteCategoryApi(params: param) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: LocalStrings.success)
                        self.getCategoryListApi()
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}
