//
//  CreateAdminViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/04/2021.
//

import UIKit
import iOSDropDown
import CropViewController

class CreateAdminAndTechViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTETS
    @IBOutlet weak var searchShadow: UIView!
    @IBOutlet weak var firstNameShadow: UIView!
    @IBOutlet weak var LastNameShadow: UIView!
    @IBOutlet weak var StoreNameShadow: UIView!
    @IBOutlet weak var StoreAddressShadow: UIView!
    @IBOutlet weak var mobileNumShadow: UIView!
    @IBOutlet weak var emailShadow: UIView!
    @IBOutlet weak var passwordShadow: UIView!
    @IBOutlet weak var ConfirmPasswordShadow: UIView!
    @IBOutlet weak var viewImgShadow: UIView!
    
    @IBOutlet weak var txtSearchList: DropDown!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtStoreName: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtStoreAddress: UITextView!
    @IBOutlet weak var viewAddStoreHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgimage: UIImageView!
    
    
    @IBOutlet weak var btnContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSelectionContainer: UIView!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var freeBtn: UIButton!
    
    //MARK: - OBJECT AND VERIABLES
    var isFromTechnician: Bool = false
    var isImageSelected: Bool = false
    var isForEdit: Bool = false
    var adminObjc: AdminViewModel?
    var typeLogin = LoginType.Admin
    var storeId: Int = 0
    var storeObj = StoreListViewModel()
    var UserId: Int = 0
    var adminListViewModel = AdminListViewModel()
    var isPayable = 0
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        self.txtSearchList.isSearchEnable = false
        super.viewDidLoad()
        self.configureDetail()
        self.configureDropShadow()
        self.configureDropDown()
        self.setupAuthObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getStoreListApi()
        self.setPayFreeBtnSelectionOption()
        if let container = self.mainContainer{
            container.delegate = self
            
            txtStoreName.isUserInteractionEnabled = false
            txtStoreAddress.isUserInteractionEnabled = false
            
            if Global.shared.user.loginType == LoginType.Admin {
                self.viewAddStoreHeight.constant = 0
                isPayable = 0
            }
            if isFromTechnician{
                if isForEdit {
                    container.setMenuButton(true, title: TitleNames.Update_Technician)
                } else {
                    container.setMenuButton(true, title: TitleNames.Create_Technician)
                }
                
                
                self.typeLogin = LoginType.Technician
            }else{ //else from admin
                container.setMenuButton(true, title: TitleNames.Create_Admin)
                self.viewAddStoreHeight.constant = 70
                
            }
        }
    }
    
    
    //MARK: - IBACTION METHODS
    
    @IBAction func addStoreAction(_ sender: Any) {
        navigateToAddStoreVC()
    }
    
    @IBAction func actionSaveChanges(_ sender: UIButton){
        
        if self.checkValidation(){
            var imageData: [String: Data]?
            
            
            if self.isImageSelected{
                imageData = [DictKeys.image: self.imgimage.image!.jpegData(compressionQuality: 0.50)!]
            }
            let params: ParamsAny = [DictKeys.first_name: self.txtFirstName.text!,
                                     DictKeys.last_name: self.txtLastName.text!,
                                     DictKeys.email: self.txtEmail.text!,
                                     DictKeys.store_name: self.txtStoreName.text!,
                                     DictKeys.store_address: self.txtStoreAddress.text!,
                                     DictKeys.phone_number: self.txtMobileNumber.text!,
                                     DictKeys.password: self.txtPassword.text!,
                                     DictKeys.login_type: typeLogin,
                                     DictKeys.Store_Id: self.storeId,
                                     DictKeys.User_Id: self.UserId,
                                     DictKeys.is_payable: isPayable,
                                     DictKeys.is_admin: 1
            ]
            if self.isForEdit{
                let updateImg = [DictKeys.image: self.imgimage.image!.jpegData(compressionQuality: 0.50)!]
                self.updateAdminProfileApi(params: params, imageData: updateImg)
                
            }else{
                self.addAdminAndTechnicianApi(params: params, imageData: imageData)
            }
        }
    }
    
    @IBAction func openDropDown(_ sender: Any) {
        txtSearchList.showList()
    }
    
    @IBAction func actionAddPhoto(_ sender: UIButton){
        self.fetchProfileImage()
    }
    
    @IBAction func payBtnAction(_ sender: Any) {
        payBtn.isSelected = true
        freeBtn.isSelected = false
        isPayable = 1
        
    }
    
    @IBAction func freeBtnAction(_ sender: Any) {
        payBtn.isSelected = false
        freeBtn.isSelected = true
        isPayable = 0
    }
    
    
    //MARK: - FUNCTIONS
    func setPayFreeBtnSelectionOption() {
        if Global.shared.user.loginType == LoginType.super_admin {
            btnContainerHeight.constant = 100
            btnSelectionContainer.isHidden = false
           
            if let obj = self.adminObjc{
                isPayable = obj.is_payable
                if isPayable == 0 {
                    payBtn.isSelected = false
                    freeBtn.isSelected = true
                   // isPayable = 0
                } else {
                    payBtn.isSelected = true
                    freeBtn.isSelected = false
                   // isPayable = 1
                }
            } else {
                payBtn.isSelected = false
                freeBtn.isSelected = true
                isPayable = 0
            }
        } else {
            btnContainerHeight.constant = 0
            btnSelectionContainer.isHidden = true
        }
    }
    
    func configureDropDown(){
        self.txtSearchList.selectedIndex = 0
        if self.storeObj.storeList.count > 0 && !isForEdit  {
            if Global.shared.user.loginType == LoginType.super_admin {
                txtSearchList.text = self.storeObj.storeList[0].name
                txtStoreName.text = self.storeObj.storeList[0].name
                txtStoreAddress.text = self.storeObj.storeList[0].address
                self.storeId = self.storeObj.storeList[0].id
            }
        }
        if UserDefaultsManager.shared.userInfo.loginType == LoginType.super_admin {
            var  indexOfStore = 0
            for (index,store) in storeObj.storeList.enumerated() {
                if store.id == self.storeId {
                    indexOfStore = index
                    break
                }
            }
            self.txtSearchList.selectedIndex = indexOfStore
        }
        self.txtSearchList.didSelect { (selectedText, index, id) in
            self.configureStoreList(idStore: self.storeObj.storeList[index].id)
            
        }
    }
    
    func configureDropShadow(){
        self.searchShadow.dropShadow(radius: 4, opacity: 0.3)
        self.firstNameShadow.dropShadow(radius: 4, opacity: 0.3)
        self.LastNameShadow.dropShadow(radius: 4, opacity: 0.3)
        self.StoreNameShadow.dropShadow(radius: 4, opacity: 0.3)
        self.StoreAddressShadow.dropShadow(radius: 4, opacity: 0.3)
        self.mobileNumShadow.dropShadow(radius: 4, opacity: 0.3)
        self.emailShadow.dropShadow(radius: 4, opacity: 0.3)
        self.passwordShadow.dropShadow(radius: 4, opacity: 0.3)
        self.ConfirmPasswordShadow.dropShadow(radius: 4, opacity: 0.3)
        self.viewImgShadow.dropShadow(radius: 4, opacity: 0.5)
        viewImgShadow.dropShadow()
        self.viewImgShadow.cornerRadius = viewImgShadow.frame.height/2
        self.viewImgShadow.clipsToBounds = true
    }
    
    func configureStoreList(idStore: Int){
        if UserDefaultsManager.shared.userInfo.loginType == LoginType.super_admin {
            let storeInfo = storeObj.getStoreDetailAganistID(storeID: idStore)
            self.txtStoreName.text = storeInfo.name
            self.txtStoreAddress.text = storeInfo.address
            self.storeId = idStore
            self.txtSearchList.text = storeInfo.name
            
            var  indexOfStore = 0
            for (index,store) in storeObj.storeList.enumerated() {
                if store.id == self.storeId {
                    indexOfStore = index
                    break
                }
            }
            self.txtSearchList.selectedIndex = indexOfStore
            
        } else {
            let id = UserDefaultsManager.shared.userInfo?.storeID
            let storeInfo = storeObj.getStoreDetailAganistID(storeID: id!)
            self.txtStoreName.text = storeInfo.name
            self.txtStoreAddress.text = storeInfo.address
            self.storeId = id ?? 0
            
            
        }
    }
    
    func configureDetail(){
        if self.isForEdit{
            if let obj = self.adminObjc{
                self.txtFirstName.text = obj.firstName
                self.txtLastName.text = obj.lastName
                self.txtEmail.text = obj.email
                self.txtMobileNumber.text = obj.phoneNumber
                self.setImageWithUrl(imageView: self.imgimage, url: obj.image, placeholderImage: AssetNames.Box_Blue)
                //self.btnSave.setTitle("Update", for: .normal)
                
                self.storeId = obj.storeID
                self.UserId = obj.id
                
            }
        }
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkValidation() -> Bool{
        var message = ""
        var isValid: Bool = true
        let isValidEmail = Validations.emailValidation(self.txtEmail.text!)
        let isValidPassword = Validations.passwordValidation(self.txtPassword.text!)
        let isValidRePassword = Validations.confirmPasswordValidation(self.txtPassword.text!, repeat: self.txtConfirmPassword.text!)
        let isPhoneValid = Validations.phoneNumberValidation(txtMobileNumber.text!)
        
        if self.txtFirstName.text!.isEmpty{
            message = ValidationMessages.Empty_First_Name
            isValid = false
            
        }else if self.txtLastName.text!.isEmpty{
            message = ValidationMessages.Empty_Last_Name
            isValid = false
            
        }else if self.txtMobileNumber.text!.isEmpty{
            message = ValidationMessages.emptyPhonNumber
            isValid = false
            
        }else if !isValidEmail.isValid{
            message = isValidEmail.message
            isValid = false
            
        }else if self.txtStoreName.text!.isEmpty{
            message = ValidationMessages.Empty_Store_Name
            isValid = false
            
        }else if self.txtStoreAddress.text!.isEmpty{
            message = ValidationMessages.Empty_Store_Address
            isValid = false
        }else if !isPhoneValid.isValid {
            message = isPhoneValid.message //ValidationMessages.enterAValidPhone
            isValid = false
        }
        
        //if isForEdit{
        else if !isValidPassword.isValid{
            message = isValidPassword.message
            isValid = false
        } else if !isValidRePassword.isValid {
            message = isValidRePassword.message
            isValid = false
        }
        //}
        
        if !isValid{
            self.showAlertView(message: message)
        }
        return isValid
    }
    
    func navigateToAddStoreVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.AddStoreViewController) as! AddStoreViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - IMAGE PICKER CONTROLLER DELEGATE METHODS
    //    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    //        self.imgimage.image = image
    //        self.isImageSelected = true
    //        picker.dismiss(animated: true, completion: nil)
    //    }
    
    override func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        self.imgimage.image = image
        self.isImageSelected = true
        // 'image' is the newly cropped version of the original image
    }
}


//MARK: - EXTENSION API CALLS
extension CreateAdminAndTechViewController{
    
    func addAdminAndTechnicianApi(params: ParamsAny, imageData: [String: Data]?){
        self.startActivity()
        GCD.async(.Background) {
            AdminTechnicianService.shared().registerAdminAndTechnicianApi(params: params, dict: imageData) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        var msg = ""
                        if self.typeLogin == LoginType.Technician{
                            msg = PopupMessages.TechAddedSuccess
                        } else if self.typeLogin ==  LoginType.Admin{
                            msg = PopupMessages.AdminAddedSuccess
                        } else {
                            msg = message
                        }
                        
                        self.showAlertView(message: msg, title: "", doneButtonTitle: LocalStrings.ok) { (UIAlertAction) in
                            self.navigationController?.popViewController(animated: true)
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
                        var msg = ""
                        if self.typeLogin == LoginType.Technician{
                            msg = PopupMessages.TechUpdatedSuccess
                        } else if self.typeLogin ==  LoginType.Admin{
                            msg = PopupMessages.AdminUpdatedSuccess
                        } else {
                            msg = message
                        }
                        self.showAlertView(message: msg, title: "", doneButtonTitle: LocalStrings.ok) { (UIAlertAction) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    //MARK: - GET STORE LIST
    func getStoreListApi(){
        self.startActivity()
        GCD.async(.Background) {
            StoreCategoryService.shared().storeListApi(params: [:]) { (message, success, storeInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        if let infoList = storeInfo{
                            self.storeObj = infoList
                            self.txtSearchList.optionArray = infoList.storeList.map({$0.name})
                            self.txtSearchList.selectedIndex = 0
                            self.configureStoreList(idStore: self.storeId)
                            self.configureDropDown()
                            
                        }
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    
}

