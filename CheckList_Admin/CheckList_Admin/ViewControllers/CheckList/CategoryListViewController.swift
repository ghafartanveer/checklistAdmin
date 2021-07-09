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
    
    //var checkListQuestionObjData : [CheckListQuestionViewModel] = []
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAuthObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Global.shared.isSubCategoryListEdited = false
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
    
    func deleteCategry(index: Int) {
        self.showAlertView(message: PopupMessages.Sure_To_Delete_Category, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
            
                            let catID = self.categoryObject.categoryList[index].id
                            self.deleteCategoryListApi(param: [DictKeys.Category_Id: catID])
            
                        }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
            
                        }
            
                    }
    
    func editCategory(index: Int) {
                    let catID = self.categoryObject.categoryList[index].id
                    let catObject = self.categoryObject.getCategoryDetailAganistID(CategoryID: catID)
                    self.moveToAddCategoryVC(isForEdit: true, catObject: catObject)
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
        subCategoryList = self.categoryObject.categoryList[indexPath.row].subCategoryList
        vc.categoryDetailObject = self.categoryObject.categoryList[indexPath.row]
//        saveTaskList(obj: self.categoryObject.categoryList[indexPath.row])
//        vc.checkListQuestionObjData = self.checkListQuestionObjData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let size = tableView.cellForRow(at: indexPath)!.frame.size.height
        let backView = UIView(frame: CGRect(x: 2, y: 0, width: 62, height: size))
        backView.dropShadow()
        let myImage = UIImageView(frame: CGRect(x: 5, y: 5, width: 60, height: size))
        myImage.contentMode = .scaleAspectFit
        myImage.image = #imageLiteral(resourceName: "delete-icon")//UIImage(named: AssetNames.Delete_Icon)
        //myImage.tintColor = .red
        myImage.backgroundColor = .white
        backView.addSubview(myImage)
       
        let imgSize: CGSize = tableView.frame.size
        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        backView.layer.render(in: context!)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let delete = UITableViewRowAction(style: .normal, title: "") { (action, indexPath) in
            print("“Delete”")
            
            self.deleteCategry(index: indexPath.row)
        
        }
        delete.backgroundColor = UIColor(patternImage: newImage)
        
        let backView1 = UIView(frame: CGRect(x: 2, y: 0, width: 62, height: size-10))
        backView1.dropShadow()
        let myImage1 = UIImageView(frame: CGRect(x: 20, y: 20, width: 40, height: size-20))
        myImage1.image = #imageLiteral(resourceName: "edit_icon") //UIImage(named: AssetNames.Edit_Icon)
        myImage1.contentMode = .scaleAspectFit
        myImage1.tintColor = .white
        backView1.addSubview(myImage1)
        myImage1.translatesAutoresizingMaskIntoConstraints = false
        myImage1.centerXAnchor.constraint(equalTo: backView1.centerXAnchor).isActive = true
        myImage1.centerYAnchor.constraint(equalTo: backView1.centerYAnchor).isActive = true
        let imgSize1: CGSize = tableView.frame.size
        UIGraphicsBeginImageContextWithOptions(imgSize1, false, UIScreen.main.scale)
        let context1 = UIGraphicsGetCurrentContext()
        backView1.layer.render(in: context1!)
        let newImage1: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let Edit = UITableViewRowAction(style: .destructive, title: "") { (action, indexPath) in
            
            self.editCategory(index: indexPath.row)
           print("Edit here")
        }
        Edit.backgroundColor = UIColor(patternImage: newImage1)
        return [delete,Edit]
    }
    
    //MARK: - CategoryListTableViewCell DELEGATE METHODS
    func callBackActionDeleteCategory(index: Int) {
        //removed
    }
    
    func callBackActionEditCategory(index: Int) {
        //removed
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
