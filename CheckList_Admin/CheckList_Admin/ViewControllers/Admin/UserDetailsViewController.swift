//
//  UserDetailsViewController.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 01/07/2021.
//

import UIKit

class UserDetailsViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTETS
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    
    @IBOutlet weak var fulNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var emailShdowView: UIView!
    @IBOutlet weak var phoneShadowView: UIView!
    
    @IBOutlet weak var technicianListContainerView: UIView!
    
    @IBOutlet weak var techListTV: UITableView!
    @IBOutlet weak var tableViewContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var contntViewHeight: NSLayoutConstraint!
    //MARK: - OBJECT AND VERIABLES
    var typeLogin = LoginType.Admin
    var techList = [AdminViewModel]()
    var adminObjc: AdminViewModel?
    var technicianObject = AdminListViewModel()
    var isFromTechnician: Bool = false
    var isImageSelected: Bool = false
    
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        techListTV.delegate = self
        techListTV.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDropShadow()
        configureDetail()
        getTechnicianListApi()
        togleEditable(isAditAble: false)
        if let container = self.mainContainer{
            container.delegate = self
            
            if isFromTechnician {
                technicianListContainerView.isHidden = true
                tableViewContainerHeight.constant = 0
                contntViewHeight.constant = 625

                container.setMenuButton(true, title: TitleNames.TechnicianDetails)
                typeLogin = LoginType.Technician
            } else {
                tableViewContainerHeight.constant = 300
                technicianListContainerView.isHidden = false
                contntViewHeight.constant = 950
                container.setMenuButton(true, title: TitleNames.AdminDetails)
                typeLogin = LoginType.Admin
            }
            
        }
    }
    
//    func getTechWithAdminId() {
//        if let obj = self.adminObjc{
//            self.techList = self.technicianObject.adminList.filter({$0.id == obj.id})
//        }
//    }
    
    //MARK: - IBACTION METHODS
    
    @IBAction func actionAddPhoto(_ sender: UIButton){
        self.fetchProfileImage()
    }
    
    @IBAction func allowToAditAction(_ sender: Any) {
        self.togleEditable(isAditAble: true)
    }
    
    @IBAction func actionSaveChanges(_ sender: UIButton){
        
        if self.checkValidation(){
            var imageData: [String: Data]?
            
            
            if self.isImageSelected{
                imageData = [DictKeys.image: self.profileImageView.image!.jpegData(compressionQuality: 0.50)!]
            }
            let params: ParamsAny = [DictKeys.first_name: self.firstNameTF.text!,
                                     DictKeys.last_name: self.lastNameTF.text!,
                                     DictKeys.email: self.emailTF.text!,
                                     DictKeys.phone_number: self.phoneTF.text!,
                                     DictKeys.login_type: typeLogin,
                                     DictKeys.Store_Id: self.adminObjc?.storeID ?? 0,
                                     DictKeys.User_Id: self.self.adminObjc?.id ?? 0]
          
//                let updateImg = [DictKeys.image: self.profileImageView.image!.jpegData(compressionQuality: 0.50)!]
                self.updateAdminProfileApi(params: params, imageData: imageData)
        }
    }
    
    // Functions
    func configureDropShadow(){
        self.emailShdowView.dropShadow(radius: 4, opacity: 0.3)
        self.phoneShadowView.dropShadow(radius: 4, opacity: 0.3)
        self.profileImageView.cornerRadius = profileImageView.frame.height/2
        self.profileImageView.clipsToBounds = true
    }
    
    func togleEditable(isAditAble:Bool) {
        addImageBtn.isHidden = !isAditAble
        firstNameTF.isUserInteractionEnabled = isAditAble
        lastNameTF.isUserInteractionEnabled = isAditAble
        emailTF.isUserInteractionEnabled = isAditAble
        if isAditAble {
            emailShdowView.borderWidth = 2.0
            emailShdowView.borderColor = .darkGray
            phoneShadowView.borderWidth = 2.0
            phoneShadowView.borderColor = .darkGray
        } else {
            emailTF.borderWidth = 0.0
            emailTF.borderColor = .clear
            phoneTF.borderWidth = 0.0
            phoneTF.borderColor = .clear
        }
       
        phoneTF.isUserInteractionEnabled = isAditAble
    }
    
    func configureDetail(){
        if let obj = self.adminObjc{
            self.fulNameLbl.text = obj.firstName + " " + obj.lastName
            self.emailLbl.text = obj.email
            self.firstNameTF.text = obj.firstName
            self.lastNameTF.text = obj.lastName
            self.emailTF.text = obj.email
            self.phoneTF.text = obj.phoneNumber
            self.setImageWithUrl(imageView: self.profileImageView, url: obj.image, placeholderImage: AssetNames.Box_Blue)
            
        }
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkValidation() -> Bool{
        var message = ""
        var isValid: Bool = true
        let isValidEmail = Validations.emailValidation(self.emailTF.text!)
        
        if self.firstNameTF.text!.isEmpty{
            message = ValidationMessages.Empty_First_Name
            isValid = false
            
        }else if self.lastNameTF.text!.isEmpty{
            message = ValidationMessages.Empty_Last_Name
            isValid = false
            
        }else if self.phoneTF.text!.isEmpty{
            message = ValidationMessages.emptyPhonNumber
            isValid = false
            
        }else if !isValidEmail.isValid{
            message = isValidEmail.message
            isValid = false
        }
        
        if !isValid{
            self.showAlertView(message: message)
        }
        return isValid
    }

    //MARK: - IMAGE PICKER CONTROLLER DELEGATE METHODS
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.profileImageView.image = image
        self.isImageSelected = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension UserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return techList.count //self.technicianObject.adminList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TechnicianDetailTableViewCell) as! TechnicianDetailTableViewCell
        
        
        //cell.configureCellDetails(info: self.technicianObject.adminList[indexPath.row], indexPath: indexPath.row)
        cell.configureTechnician(info: self.techList[indexPath.row], indexP: indexPath.row)
        
        
        
        cell.shadowView.dropShadow(radius: 5, opacity: 0.4)
        cell.userImageView.cornerRadius = cell.userImageView.frame.width/2
        print(cell.userImageView.frame.width/2)
        cell.userImageView.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}

extension UserDetailsViewController {
    func getTechnicianListApi(){
        self.startActivity()
        GCD.async(.Background) {
            AdminTechnicianService.shared().technicianListApi(params: [:]) { (message, success, adminInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success{
                        if let admin = adminInfo{
                            self.technicianObject = admin
                            
                            if let obj = self.adminObjc{
                                self.techList = self.technicianObject.adminList.filter({$0.storeID == obj.storeID})
                            }
                            
                            self.techListTV.reloadData()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    func updateAdminProfileApi(params: ParamsAny, imageData: [String: Data]?){
        self.startActivity()
        GCD.async(.Background) {
            AdminTechnicianService.shared().updateAdminAndTechnicianApi(params: params, dict: imageData) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: "", doneButtonTitle: LocalStrings.ok) { (UIAlertAction) in
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

