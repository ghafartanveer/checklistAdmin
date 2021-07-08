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
        vc.storeObj = storeInfo
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        //                let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.WorkListViewController) as! WorkListViewController
        //                self.navigationController?.pushViewController(vc, animated: true)
        //            }
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "", handler: {a,b,c in
            //delete Action here
            self.showAlertView(message: PopupMessages.Sure_To_Delete_Technician, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
                
                self.showAlertView(message: PopupMessages.Sure_To_Delete_Store, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
                    
                    let delStoreId = self.storeObject.storeList[indexPath.row].id
                    self.deleteStoreApi(param: [DictKeys.Store_Id: delStoreId])
                    
                }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
                    
                }
                
            }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
                
            }
        })
        
        deleteAction.image = UIImage(named: AssetNames.swipeDelete)
        deleteAction.backgroundColor = .red
        
        
        let aditAction = UIContextualAction(style: .normal, title: "", handler: {a,b,c in
            //Adit Action here
            let ID = self.storeObject.storeList[indexPath.row].id
            let object = self.storeObject.getStoreDetailAganistID(storeID: ID)
            self.moveToAddStoreVC(isFromEdit: true, storeInfo: object)
        })
        
        aditAction.image = UIImage(named: AssetNames.swipeAdit)
        aditAction.backgroundColor = .white
        
        return UISwipeActionsConfiguration(actions: [deleteAction,aditAction])
        
    }

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


