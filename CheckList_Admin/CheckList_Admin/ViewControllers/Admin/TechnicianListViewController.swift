//
//  TechnicianListViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 06/05/2021.
//


import UIKit

class TechnicianListViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewTabel: UITableView!
    
    
    //MARK: - OBJECT AND VERIBALES
    var technicianObject = AdminListViewModel()
    var blockIndex: Int = -1
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAuthObserver()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Technician)
        }
        self.getTechnicianListApi()
    }
    
    //MARK: - FUNCTIOND
    func actionBack() {
        self.loadHomeController()
    }
    
    func moveToAddTechnicianVC(isForEdit: Bool, techObj: AdminViewModel?){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CreateAdminAndTechViewController) as! CreateAdminAndTechViewController
        vc.isFromTechnician = true
        vc.isForEdit = isForEdit
        vc.adminObjc = techObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - IBACTION METHODS
    @IBAction func actionAddTechnician(_ sender: UIButton){
        self.moveToAddTechnicianVC(isForEdit: false, techObj: nil)
    }
    
    
}
//MARK: - EXTENSION TABEL VIEW METHODS
extension TechnicianListViewController: UITableViewDelegate, UITableViewDataSource, TechnicianListTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.technicianObject.adminList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TechnicianListTableViewCell) as! TechnicianListTableViewCell
        cell.delegate = self
        cell.configureTechnician(info: self.technicianObject.adminList[indexPath.row], indexP: indexPath.row)
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
    
    //MARK: - TechnicianListTableViewCell DELEGATE METHODS
    func callBackActionDeleteTechnician(index: Int) {
        self.showAlertView(message: PopupMessages.Sure_To_Delete_Technician, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
            
            let techID = self.technicianObject.adminList[index].id
            self.deleteTechnicianApi(param: [DictKeys.User_Id: techID])
            
        }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
            
        }
    }
    
    func callBackActionEditTechnician(index: Int) {
        let techID = self.technicianObject.adminList[index].id
        let object = self.technicianObject.getAdminDetailAganistID(AdminID: techID)
        self.moveToAddTechnicianVC(isForEdit: true, techObj: object)
    }
    func callBackActionBlockUnBlockTechnician(index: Int) {
        let techID = self.technicianObject.adminList[index].id
        self.blockIndex = index
        self.blockUnblockTechnicianApi(param: [DictKeys.User_Id: techID])
    }
    
    
}
//MARK: - EXTENSION API CALLS
extension TechnicianListViewController{
    func getTechnicianListApi(){
        self.startActivity()
        GCD.async(.Background) {
            AdminTechnicianService.shared().technicianListApi(params: [:]) { (message, success, adminInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success{
                        if let admin = adminInfo{
                            self.technicianObject = admin
                            self.viewTabel.reloadData()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    func deleteTechnicianApi(param: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            AdminTechnicianService.shared().deleteAdminOrTechnicianApi(params: param) { (message, success, adminInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: LocalStrings.success)
                        self.getTechnicianListApi()
                        
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
                        if self.technicianObject.adminList[self.blockIndex].isBlock == 0{
                            self.technicianObject.adminList[self.blockIndex].isBlock = 1
                        }else{
                            self.technicianObject.adminList[self.blockIndex].isBlock = 0
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


