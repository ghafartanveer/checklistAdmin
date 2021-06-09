//
//  AdminListViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/04/2021.
//

import UIKit

class AdminListViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewTabel: UITableView!
    
    
    //MARK: - OBJECT AND VERIBALES
    var adminObject = AdminListViewModel()
    var adminIndex: Int = -1
    
    
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAuthObserver()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Admin_List)
        }
        self.getAdminListApi()
    }
    
    //MARK: - FUNCTIOND
    func actionBack() {
        self.loadHomeController()
    }
    
    
    
    //MARK: - IBACTION METHODS
    @IBAction func actionAddAdmin(_ sender: UIButton){
        self.moveToCreateAdminAndTechnicianVC(isForEdit: false, adminObject: nil)
    }
    
    
}
//MARK: - EXTENSION TABEL VIEW METHODS
extension AdminListViewController: UITableViewDelegate, UITableViewDataSource, AdminListTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.adminObject.adminList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.AdminListTableViewCell) as! AdminListTableViewCell
        cell.delegate = self
        cell.configureAdmin(info: self.adminObject.adminList[indexPath.row], indexPath: indexPath.row)
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
        return 150
    }
    
    //MARK: - AdminListTableViewCell DELEGATE METHODS
    func callBackActionDeleteAdmin(index: Int) {
        self.showAlertView(message: PopupMessages.Sure_To_Delete_Admin, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
            
            let userID = self.adminObject.adminList[index].id
            self.deleteAdminApi(param: [DictKeys.User_Id: userID])
            
        }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
            
        }
    }
    
    func callBackActionEditAdmin(index: Int) {
       let adminObj = self.adminObject.getAdminDetailAganistID(AdminID: self.adminObject.adminList[index].id)
        self.moveToCreateAdminAndTechnicianVC(isForEdit: true, adminObject: adminObj)
    }
    
    func callBackActionBlockUnBlockAdmin(index: Int) {
        let adminID = self.adminObject.adminList[index].id
        self.adminIndex = index
        self.blockUnblockTechnicianApi(param: [DictKeys.User_Id: adminID])
    }
    
}
//MARK: - EXTENSION API CALLS
extension AdminListViewController{
    func getAdminListApi(){
        self.startActivity()
        GCD.async(.Background) {
            AdminTechnicianService.shared().adminListApi(params: [:]) { (message, success, adminInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success{
                        if let admin = adminInfo{
                            self.adminObject = admin
                            self.viewTabel.reloadData()
                        }
                       
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    func deleteAdminApi(param: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            AdminTechnicianService.shared().deleteAdminOrTechnicianApi(params: param) { (message, success, adminInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: LocalStrings.success)
                        self.getAdminListApi()
                       
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    func blockUnblockTechnicianApi(param: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            AdminTechnicianService.shared().blockAdminOrTechnicianApi(params: param) { (message, success, adminInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message)
                        if self.adminObject.adminList[self.adminIndex].isBlock == 0{
                            self.adminObject.adminList[self.adminIndex].isBlock = 1
                        }else{
                            self.adminObject.adminList[self.adminIndex].isBlock = 0
                        }
                        self.viewTabel.reloadData()
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
}


