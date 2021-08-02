//
//  CreateCheckListViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 27/04/2021.
//

import UIKit

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
        let catViewModel = CategoryViewModel()

        
        if !Global.shared.isSubCategoryListEdited {
            Global.shared.subCategoryList.removeAll()
            Global.shared.subCatIdsToDel.removeAll()
        self.navigationController?.popViewController(animated: true)
        } else  {
            
            self.showAlertView(message: PopupMessages.sureToGoBackWithOutSaving, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
                Global.shared.subCategoryList.removeAll()
                Global.shared.subCatIdsToDel.removeAll()
                self.navigationController?.popViewController(animated: true)
            }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
                
            }

        }
    }
    
    func moveToAddTaskVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CreateNewTaskViewController) as! CreateNewTaskViewController
        vc.categoryObj = categoryDetailObject
        vc.indexToAdit = indexToAdit
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteSubCategoryAction(index: Int) {
        
        
        self.showAlertView(message: PopupMessages.Sure_To_Delete_Task, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
            Global.shared.subCatIdsToDel.append(Global.shared.subCategoryList[index].id)
            Global.shared.subCategoryList.remove(at: index)
            self.subCatTV.reloadData()
        }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
            
        }
    }
    
    func aditAction(index: Int) {
        self.indexToAdit = index
        self.moveToAddTaskVC()
    }
    //MARK: - IBAtion
    
    @IBAction func addTaskAction(_ sender: Any) {
        indexToAdit = -1
        moveToAddTaskVC()
    }
    
    @IBAction func submitCategoryAction(_ sender: Any) {
            
        let catViewModel = CategoryViewModel()
        catViewModel.subCategoryList = Global.shared.subCategoryList
        categoryDetailObject.subCategoryList = Global.shared.subCategoryList
        
        var paramsDic = categoryDetailObject.getParams()
        let dummyIds = [0,-1]
        Global.shared.subCatIdsToDel.removeAll(where: { dummyIds.contains($0) })
        if Global.shared.subCatIdsToDel.count > 0 {
            paramsDic = categoryDetailObject.getParams(ids: Global.shared.subCatIdsToDel)
        }
  //catViewModel.getParams()
        print(paramsDic)
        submitCategoryApi(params: paramsDic)
       // subCategoryList.removeAll()
        
    }
}
//MARK: - EXTENSION TABEL VIEW METHODS
extension SubCategoryListViewController: UITableViewDelegate, UITableViewDataSource, SubCategoryListTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.shared.subCategoryList.count
       
//        else{
//            self.showAlertView(message: "No subcategory list found")
//            return 0
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SubCategoryListTableViewCell) as! SubCategoryListTableViewCell
        
        cell.configureSubCategory(info: Global.shared.subCategoryList[indexPath.row])
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
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
    
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .normal, title: "", handler: {a,b,c in
//            //delete Action here
//            self.showAlertView(message: PopupMessages.Sure_To_Delete_Task, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
//
//                subCategoryList.remove(at: indexPath.row)
//                tableView.reloadData()
//            }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
//
//            }
//        })
//
//        deleteAction.image = UIImage(named: AssetNames.swipeDelete)
//        deleteAction.backgroundColor = .red
//
//
//        let aditAction = UIContextualAction(style: .normal, title: "", handler: {a,b,c in
//            //Adit Action here
//            self.indexToAdit = indexPath.row
//            self.moveToAddTaskVC()
//
//        })
//
//        aditAction.image = UIImage(named: AssetNames.swipeAdit)
//        aditAction.backgroundColor = .white
//
//        return UISwipeActionsConfiguration(actions: [deleteAction,aditAction])
//
//    }
    
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
