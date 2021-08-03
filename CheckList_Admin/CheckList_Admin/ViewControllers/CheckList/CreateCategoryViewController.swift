//
//  CreateCategoryViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/05/2021.
//

import UIKit

class CreateCategoryViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewTxtShadow: UIView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var viewTabel: UITableView!
    @IBOutlet weak var viewTabelList: UITableView!
    @IBOutlet weak var viewTabelHeight: NSLayoutConstraint!
    
    //MARK: - OBJECT AND VERIBALES
    var categoryObj = CategoryListViewModel()
   /// var subCatList = [SubCategoryViewModel]()
    var indexToAditSubCat = -1
    //var subCatIdsToDel:[Int] = []
    //
    var selectedCatieModel = CategoryViewModel()
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewTabel.addGestureRecognizer(tap)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Global.shared.isAddingSubTask == false {
         getCategoryListApi()
        }
        
        viewTabel.reloadData()
       
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Create_Check_List)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.viewTabelHeight.constant = 0
    }
    
    //MARK: - IBACTION METHODS

    
    @IBAction func actionAddCategory(_ sender: UIButton){
        Global.shared.isAddingSubTask = false

        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.AddCategoryViewController) as! AddCategoryViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionAddSubCategory(_ sender: UIButton){
        indexToAditSubCat = -1
        Global.shared.isAddingSubTask = true
        self.moveToAddTaskVC()
    }
    
    @IBAction func actionOpenCategoryList(_ sender: UIButton){
        self.viewTabelHeight.constant = 200
    }
    
    @IBAction func actionSubmit(_ sender: UIButton){
        Global.shared.isAddingSubTask = false

        let catViewModel = CategoryViewModel()
        catViewModel.subCategoryList = Global.shared.subCategoryList
        selectedCatieModel.subCategoryList = Global.shared.subCategoryList
        //print("Category ID: ",selectedCatieModel.id)
        
        var paramsDic = selectedCatieModel.getParams()  //catViewModel.getParams()
       let dummyIds = [0,-1]
        Global.shared.subCatIdsToDel.removeAll(where: { dummyIds.contains($0) })
        if Global.shared.subCatIdsToDel.count > 0 {
            paramsDic = selectedCatieModel.getParams(ids: Global.shared.subCatIdsToDel)
        }
        print(paramsDic)
        submitCategoryApi(params: paramsDic)
    }
    
    //MARK: - FUNCTIONS
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.viewTabelHeight.constant = 0
    }
    
    func setupDropDown() {
        self.txtTitle.text = self.categoryObj.categoryList[Global.shared.indexOfCategory].name
        //indexToAdit = 0
        ///self.subCatList = self.categoryObj.categoryList[Global.shared.indexOfCategory].subCategoryList
        
        self.viewTxtShadow.dropShadow(radius: 4, opacity: 0.3)
        self.viewTabelHeight.constant = 0
        
   
        self.selectedCatieModel = self.categoryObj.categoryList[Global.shared.indexOfCategory]
       
        Global.shared.subCategoryList = self.categoryObj.categoryList[Global.shared.indexOfCategory].subCategoryList

        viewTabelList.reloadData()
        viewTabel.reloadData()

            
    }
    
    func moveToAddTaskVC() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CreateNewTaskViewController) as! CreateNewTaskViewController
        vc.indexToAdit = indexToAditSubCat
        vc.categoryObj = self.selectedCatieModel
        
        // self.categoryObj.categoryList[indexToAdit]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func actionBack() {
        if !Global.shared.isSubCategoryListEdited {
            Global.shared.isAddingSubTask = false
            Global.shared.subCategoryList.removeAll()
            Global.shared.subCatIdsToDel.removeAll()
            self.navigationController?.popViewController(animated: true)
        } else  {
            
            self.showAlertView(message: PopupMessages.sureToGoBackWithOutSaving, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
                Global.shared.isAddingSubTask = false
                Global.shared.subCategoryList.removeAll()
                Global.shared.subCatIdsToDel.removeAll()
                self.navigationController?.popViewController(animated: true)
            }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
                
            }
            
        }
    }
    
    func configureTabelViewList(){
        if self.categoryObj.categoryList.count > 0{
            self.viewTabelList.reloadData()
        }
    }

    func deleteSubCategoryAction(index: Int) {
        Global.shared.subCatIdsToDel.append(Global.shared.subCategoryList[index].id)
        Global.shared.subCategoryList.remove(at: index)
        self.viewTabel.reloadData()
        
//        self.showAlertView(message: PopupMessages.Sure_To_Delete_Task, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
//        }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
//        }
        
    }
    
    func aditAction(index: Int) {
        Global.shared.isAddingSubTask = true

        self.indexToAditSubCat = index
        self.moveToAddTaskVC()
    }
}

//MARK: - EXTENSION TABEL VIEW METHODS
extension CreateCategoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.viewTabelList{
            return self.categoryObj.categoryList.count
        }else{
            //return self.subCatList.count
            return Global.shared.subCategoryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.viewTabelList{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CategoryDropDownTableViewCell) as! CategoryDropDownTableViewCell
            cell.lblName.text = self.categoryObj.categoryList[indexPath.row].name
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CreateSubCategoryTableViewCell) as! CreateSubCategoryTableViewCell
            cell.configureSubCategory(info: Global.shared.subCategoryList[indexPath.row])
            //cell.configureSubCategory(info: self.subCategoryList[indexPath.row])
            cell.viewShadow.dropShadow(radius: 5, opacity: 0.4)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == viewTabelList {
            self.txtTitle.text = self.categoryObj.categoryList[indexPath.row].name
            Global.shared.indexOfCategory = indexPath.row
            //self.indexToAdit = indexPath.row
            
            //vc.categoryDetailObject = self.categoryObject.categoryList[index]
            Global.shared.subCategoryList = self.categoryObj.categoryList[indexPath.row].subCategoryList
            self.selectedCatieModel = self.categoryObj.categoryList[indexPath.row]
            Global.shared.indexOfCategory = indexPath.row
            // self.subCategoryList = self.categoryObj.categoryList[indexPath.row].subCategoryList
            Global.shared.subCategoryList = self.categoryObj.categoryList[indexPath.row].subCategoryList
            self.viewTabel.reloadData()
        }
        self.viewTabelHeight.constant = 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.viewTabelList{
            return 30
        }else{
            return 200
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView == viewTabel {
            let size = tableView.cellForRow(at: indexPath)!.frame.size.height
            let backView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: size-20))
            backView.backgroundColor = .white
            backView.dropShadow()
            let myImage = UIImageView(frame: CGRect(x: 5, y: 17, width: 30, height: 35))
            
            myImage.center = backView.frame.center
            
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
                
                
                self.deleteSubCategoryAction(index: indexPath.row)
                
            }
            delete.backgroundColor = UIColor(patternImage: newImage)
            let backView1 = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: size-20))
            backView1.dropShadow()
            backView1.backgroundColor = .white
            let myImage1 = UIImageView(frame: CGRect(x: 5, y: 0, width: 35, height: 40))
            myImage1.image = #imageLiteral(resourceName: "edit-icon") //UIImage(named: AssetNames.Edit_Icon)
            myImage1.tintColor = .darkGray
            myImage1.contentMode = .scaleAspectFit
            myImage1.backgroundColor = .white
            backView1.addSubview(myImage1)
            myImage1.center = backView1.frame.center
            
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
                
                print("Edit here")
                self.aditAction(index: indexPath.row)
            }
            Edit.backgroundColor = UIColor(patternImage: newImage1)
            return [delete,Edit]
        }
        return []
    }
    
}

//MARK: - EXTENSION API CALLS
extension CreateCategoryViewController{
    func getCategoryListApi(){
        self.startActivity()
        GCD.async(.Background) {
            StoreCategoryService.shared().categoryListApi(params: [:]) { (message, success, catInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success{
                        if let category = catInfo{
                            self.categoryObj = category
                            
                            self.setupDropDown()
                           // self.viewTabelList.reloadData()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}

//MARK: - Server calls
extension CreateCategoryViewController {
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
                        Global.shared.subCategoryList.removeAll()
                        Global.shared.subCatIdsToDel.removeAll()
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
