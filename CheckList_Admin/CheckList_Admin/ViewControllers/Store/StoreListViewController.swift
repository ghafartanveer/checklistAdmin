//
//  StoreListViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 06/05/2021.
//

import UIKit

class StoreListViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewTabel: UITableView!
    
    
    //MARK: - OBJECT AND VERIBALES
    var storeObject = StoreListViewModel()
    
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Store_List)
        }
        self.getStoreListApi()
    }
    
    //MARK: - FUNCTIONS
    func actionBack() {
        self.loadHomeController()
    }
    
    func moveToAddStoreVC(isFromEdit: Bool, storeInfo: StoreViewModel?){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.AddStoreViewController) as! AddStoreViewController
        vc.isFromEditStore = isFromEdit
        vc.storeObj = storeInfo ?? StoreViewModel()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteStore(index : Int){
        self.showAlertView(message: PopupMessages.Sure_To_Delete_Store, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
            
            let delStoreId = self.storeObject.storeList[index].id
            self.deleteStoreApi(param: [DictKeys.Store_Id: delStoreId])
            
        }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
            
        }
    }
    
    func aditStore(index: Int) {
        let ID = self.storeObject.storeList[index].id
        let object = self.storeObject.getStoreDetailAganistID(storeID: ID)
        self.moveToAddStoreVC(isFromEdit: true, storeInfo: object)
    }

    
    
    //MARK: - IBACTION METHODS
    @IBAction func actionAddStore(_ sender: UIButton){
        self.moveToAddStoreVC(isFromEdit: false, storeInfo: nil)
    }
    
    
}
//MARK: - EXTENSION TABEL VIEW METHODS
extension StoreListViewController: UITableViewDelegate, UITableViewDataSource, StoreListTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeObject.storeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.StoreListTableViewCell) as! StoreListTableViewCell
        cell.delegate = self
        cell.configureStore(info: self.storeObject.storeList[indexPath.row], indexP: indexPath.row)
        cell.viewShadow.dropShadow(radius: 5, opacity: 0.4)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.StoreWorkerListViewController) as! StoreWorkerListViewController
        vc.store = self.storeObject.storeList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    //MARK: - AdminListTableViewCell DELEGATE METHODS
    func callBackActionDeleteStore(index: Int) {
        //removed
    }
    
    func callBackActionEditStore(index: Int) {
        //removed
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let size = tableView.cellForRow(at: indexPath)!.frame.size.height
        
        let backView = UIView(frame: CGRect(x: 5, y: 0, width: 70, height: size))
        let innerView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: size-20))
        let myImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 35))
        
        myImage.center = innerView.frame.center
        innerView.center = backView.frame.center
        
        backView.addSubview(innerView)
        innerView.addSubview(myImage)
        
        backView.backgroundColor = .clear
        innerView.backgroundColor = .white
        innerView.dropShadow()
        myImage.contentMode = .scaleAspectFit
        myImage.image = #imageLiteral(resourceName: "delete-icon") // deleteImage
        
        myImage.backgroundColor = .white
        
        
        
        
        
        
        
//        let size = tableView.cellForRow(at: indexPath)!.frame.size.height
//        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: size-20))
//        backView.dropShadow()
//        let myImage = UIImageView(frame: CGRect(x: 5, y: 0, width: 70, height: size-20))
//        myImage.contentMode = .scaleAspectFit
 //       myImage.image = #imageLiteral(resourceName: "delete-icon")//UIImage(named: AssetNames.Delete_Icon)
        //myImage.tintColor = .red
//        myImage.backgroundColor = .white
//        backView.addSubview(myImage)
        
        let imgSize: CGSize = tableView.frame.size
        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        backView.layer.render(in: context!)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let delete = UITableViewRowAction(style: .normal, title: "") { (action, indexPath) in
            print("“Delete”")
            
            
            self.deleteStore(index: indexPath.row)
            
        }
        delete.backgroundColor = UIColor(patternImage: newImage)
        
//        let backView1 = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: size-20))
//        backView1.dropShadow()
//        backView1.backgroundColor = .white
//        let myImage1 = UIImageView(frame: CGRect(x: 5, y: 0, width: 70, height: size-20))
//        myImage1.image = #imageLiteral(resourceName: "edit-icon") //UIImage(named: AssetNames.Edit_Icon)
//        myImage1.tintColor = .gray
//        myImage1.contentMode = .scaleAspectFit
//        myImage1.backgroundColor = .white
//        backView1.addSubview(myImage1)
        
        let backView1 = UIView(frame: CGRect(x: 5, y: 0, width: 70, height: size))
        let innerView1 = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: size-20))
        let myImage1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 35))
        
        myImage1.center = innerView1.frame.center
        innerView1.center = backView1.frame.center
        
        backView1.addSubview(innerView1)
        innerView1.addSubview(myImage1)
        
        backView1.backgroundColor = .clear
        innerView1.backgroundColor = .white
        myImage1.backgroundColor = .white
        
        innerView1.dropShadow()
        myImage1.contentMode = .scaleAspectFit
        
        myImage1.image = #imageLiteral(resourceName: "edit_icon") //UIImage(named: AssetNames.Edit_Icon)

        
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
            self.aditStore(index: indexPath.row)
        }
        Edit.backgroundColor = UIColor(patternImage: newImage1)
        return [delete,Edit]
    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .normal, title: "", handler: {a,b,c in
//            //delete Action here
//            self.showAlertView(message: PopupMessages.Sure_To_Delete_Technician, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
//
//                self.showAlertView(message: PopupMessages.Sure_To_Delete_Store, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
//
//                    let delStoreId = self.storeObject.storeList[indexPath.row].id
//                    self.deleteStoreApi(param: [DictKeys.Store_Id: delStoreId])
//
//                }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
//
//                }
//
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
//            let ID = self.storeObject.storeList[indexPath.row].id
//            let object = self.storeObject.getStoreDetailAganistID(storeID: ID)
//            self.moveToAddStoreVC(isFromEdit: true, storeInfo: object)
//        })
//
//        aditAction.image = UIImage(named: AssetNames.swipeAdit)
//        aditAction.backgroundColor = .white
//
//        return UISwipeActionsConfiguration(actions: [deleteAction,aditAction])
//
//    }

}

//MARK: - EXTENSION API CALLS
extension StoreListViewController{
    func getStoreListApi(){
        self.startActivity()
        GCD.async(.Background) {
            StoreCategoryService.shared().storeListApi(params: [:]) { (message, success, storeInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success{
                        self.storeObject.storeList.removeAll()
                        if let store = storeInfo{
                            self.storeObject = store
                            self.viewTabel.reloadData()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    func deleteStoreApi(param: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            StoreCategoryService.shared().deleteStoreApi(params: param) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        
                        self.showAlertView(message: message)
                        self.getStoreListApi()
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
}


