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
    
    func aditTechAction(index: Int) {
        if Global.shared.user.loginType == LoginType.Admin {
            let techID = self.technicianObject.adminList[index].id
            let object = self.technicianObject.getAdminDetailAganistID(AdminID: techID)
            self.moveToAddTechnicianVC(isForEdit: true, techObj: object)
        } else {
            self.showAlertView(message: PopupMessages.PleaseLogInAsAdmin)

        }
        
        

    }
    
    func dleteTech(index: Int) {
        if Global.shared.user.loginType == LoginType.Admin {
            self.showAlertView(message: PopupMessages.Sure_To_Delete_Technician, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
                let techID = self.technicianObject.adminList[index].id
                self.deleteTechnicianApi(param: [DictKeys.User_Id: techID])
                
            }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
            }
        } else {
            self.showAlertView(message: PopupMessages.PleaseLogInAsAdmin)

        }
       

        
    }

    
    //MARK: - IBACTION METHODS
    @IBAction func actionAddTechnician(_ sender: UIButton){
        if Global.shared.user.loginType == LoginType.super_admin {
            self.showAlertView(message: PopupMessages.PleaseLogInAsAdmin)
        } else {
            self.moveToAddTechnicianVC(isForEdit: false, techObj: nil)
        }
       
    }
    
    
}
//MARK: - EXTENSION TABEL VIEW METHODS
extension TechnicianListViewController: UITableViewDelegate, UITableViewDataSource, TechnicianListTableViewCellDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.technicianObject.adminList.count
    }
    
   
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
//                print("more button tapped")
//            }
//            more.backgroundColor = .lightGray
//
//
//            let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
//                print("favorite button tapped")
//            }
//            favorite.backgroundColor = .orange
//
//            let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
//                print("share button tapped")
//            }
//            share.backgroundColor = .blue
//
//            return [share, favorite, more]
//    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (editingStyle == UITableViewCell.EditingStyle.delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//        }
//    
//        
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
//        let size = tableView.cellForRow(at: indexPath)!.frame.size.height
//        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: size-20))
//        backView.dropShadow()
//        let myImage = UIImageView(frame: CGRect(x: 5, y: 0, width: 70, height: size-20))
//        myImage.contentMode = .scaleAspectFit
//        myImage.image = #imageLiteral(resourceName: "delete-icon")//UIImage(named: AssetNames.Delete_Icon)
//        //myImage.tintColor = .red
//        myImage.backgroundColor = .white
//        backView.addSubview(myImage)
//        
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
        
        
        let imgSize: CGSize = tableView.frame.size
        
        
        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        backView.layer.render(in: context!)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let delete = UITableViewRowAction(style: .normal, title: "") { (action, indexPath) in
            print("“Delete”")
        
            self.dleteTech(index: indexPath.row)
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
            self.aditTechAction(index: indexPath.row)
        }
        Edit.backgroundColor = UIColor(patternImage: newImage1)
        return [delete,Edit]
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .normal, title: "", handler: {a,b,c in
//            //delete Action here
//            self.showAlertView(message: PopupMessages.Sure_To_Delete_Technician, title: LocalStrings.Warning, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
//
//                let techID = self.technicianObject.adminList[indexPath.row].id
//                self.deleteTechnicianApi(param: [DictKeys.User_Id: techID])
//
//            }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
//
//            }
//            //tableView.deleteRows(at: [indexPath], with: .automatic)
//        })
//
//        deleteAction.image = UIImage(named: AssetNames.swipeDelete)
//        deleteAction.backgroundColor = .red
//
//
//        let aditAction = UIContextualAction(style: .normal, title: "", handler: {a,b,c in
//            //Adit Action here
//
//        })
//
//        aditAction.image = UIImage(named: AssetNames.swipeAdit)
//        aditAction.backgroundColor = .white
//
//        return UISwipeActionsConfiguration(actions: [deleteAction,aditAction])
//
//    }

    
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
        //removed
    }
    
    func callBackActionEditTechnician(index: Int) {
        //removed
    }
    
    func callBackActionBlockUnBlockTechnician(index: Int) {
        let techID = self.technicianObject.adminList[index].id
        self.blockIndex = index
        self.blockUnblockTechnicianApi(param: [DictKeys.User_Id: techID])
    }
    
    func callBackActionSeeDetailsTechnician(index: Int) {
        let techObj = self.technicianObject.getAdminDetailAganistID(AdminID: self.technicianObject.adminList[index].id)
        
        let techID = self.technicianObject.adminList[index].id
    
        self.moveToAdminAndTechnicianDetailsVC(adminObject: techObj, isFromTechnician: true)
        print("Tech Details button click at : ", index)
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


