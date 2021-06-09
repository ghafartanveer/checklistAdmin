//
//  SideMenuViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 27/04/2021.
//

import UIKit


class SideMenuViewController: BaseViewController {
    //MARK: - IBOUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionLogOut(_ sender: UIButton){
        self.showAlertView(message: PopupMessages.sureToLogout, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok, doneButtonCompletion: { (UIAlertAction) in
            self.logoutApiCall()
        }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
            
        }
    }
    
    //MARK: - FUNCTIONS
    func refreshData(){
        if let info = Global.shared.user{
            self.lblTitle.text = info.firstName + " " + info.lastName
            self.lblEmail.text = info.email
            self.setImageWithUrl(imageView: self.imgUser, url: info.image, placeholderImage: AssetNames.Box_Blue)
        }
    }
}


//MARK: - EXTENISON TABEL VIEW METHODS
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenu.MENULIST.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SideMenuTableViewCell) as! SideMenuTableViewCell
        cell.configureMenu(info: SideMenu.MENULIST[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let container = self.revealViewController()?.frontViewController as? MainContainerViewController{
            self.revealViewController()?.revealToggle(nil)
            
            if indexPath.row == 0{
                container.showAdminController()
                
            }else if indexPath.row == 1{
                container.showTechnicianController()
                
            }else if indexPath.row == 2{
                container.showCategoryController()
                
            }else if indexPath.row == 3{
                container.showStoreListController()
                
            }else if indexPath.row == 4{
                container.showSettingController()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Global.shared.user.loginType == LoginType.Admin{
            if indexPath.row == 0 || indexPath.row == 3{
                return 0
            }else{
                return 60
            }
        }else{
            return 60
        }
    }
    
    
}

//MARK: - EXTENSION API CALLS
extension SideMenuViewController{
    func logoutApiCall(){
        self.startActivity()
        GCD.async(.Background) {
            LoginService.shared().logoutUserApi(params: [:]) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
                            self.logoutUserAccount()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
}
