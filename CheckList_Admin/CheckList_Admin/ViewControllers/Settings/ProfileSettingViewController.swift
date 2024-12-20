//
//  SettingViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 06/05/2021.
//

import UIKit
import CropViewController

class ProfileSettingViewController: BaseViewController, TopBarDelegate {
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var fNameUnderLineView: UIView!
    @IBOutlet weak var lNameUnderLineView: UIView!
    @IBOutlet weak var emailUnderLineView: UIView!
    @IBOutlet weak var phoneUnderLineView: UIView!
    
    //MARK: - OBJECT AND VERIABLES
   
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewShadow.dropShadow(radius: 5, opacity: 0.4)
        self.configureUserInfo()
        self.setupAuthObserver()
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtPhone.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Setting)
        }
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionChangePassword(_ sender: UIButton){
        self.showChangePasswordPopUP()
        self.alertView?.show()
    }
    
    @IBAction func actionChoosePhoto(_ sender:UIButton){
        self.fetchProfileImage()
    }
    
    @IBAction func actionSave(_ sender:UIButton){
        if self.checkValidation(){
            var imageData: [String: Data]?
            let params: ParamsAny = [DictKeys.first_name: self.txtFirstName.text!,
                                     DictKeys.last_name: self.txtLastName.text!,
                                     DictKeys.email: self.txtEmail.text!,
                                     DictKeys.phone_number: self.txtPhone.text!,
                                     DictKeys.Store_Id: Global.shared.user.storeID,
                                     DictKeys.User_Id: Global.shared.user.id, DictKeys.login_type: Global.shared.user.loginType , DictKeys.is_payable: Global.shared.user.is_payable]
           
            if let profileImg = self.imgProfile.image {
                imageData = [DictKeys.image: profileImg.jpegData(compressionQuality: 0.50)!]
            } else {
                let image: UIImage = #imageLiteral(resourceName: "BoxBlue")
                imageData = [DictKeys.image: image.jpegData(compressionQuality: 0.50)!]
            }
            
            //imageData = [DictKeys.image: self.imgProfile.image!.jpegData(compressionQuality: 0.50)!]
            self.ProfileUpdateApi(params: params, imageData: imageData)
        }
    }
    
    //MARK: - FUNCTIONS
    
    func setUnderLineBGColor(view: UIView) {
        
        let inativeBottomLinecolor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        fNameUnderLineView.backgroundColor = inativeBottomLinecolor
        lNameUnderLineView.backgroundColor = inativeBottomLinecolor
        emailUnderLineView.backgroundColor = inativeBottomLinecolor
        phoneUnderLineView.backgroundColor = inativeBottomLinecolor
        view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.3450980392, blue: 0.3960784314, alpha: 1)
    }
    
    func actionBack() {
        self.loadHomeController()
    }
    
    func checkValidation() -> Bool{
        var message = ""
        var isValid: Bool = true
        let isValidEmail = Validations.emailValidation(self.txtEmail.text!)
        
        let isPhoneValid = Validations.phoneNumberValidation(txtPhone.text!)
        
        if self.txtFirstName.text!.isEmpty{
            message = ValidationMessages.Empty_First_Name
            isValid = false
            
            
        }else if self.txtLastName.text!.isEmpty{
            message = ValidationMessages.Empty_Last_Name
            isValid = false
            
        }else if self.txtPhone.text!.isEmpty{
            message = ValidationMessages.emptyPhonNumber
            isValid = false
            
        }else if !isValidEmail.isValid{
            message = isValidEmail.message
            isValid = false
        } else if !isPhoneValid.isValid {
            message = isPhoneValid.message
            isValid = false
        }
        

        if !isValid{
            self.showAlertView(message: message)
        }
        return isValid
    }
    
    func configureUserInfo(){
            let info = Global.shared.user
            self.txtFirstName.text = info.firstName
            self.txtLastName.text = info.lastName
            self.txtEmail.text = info.email
            self.txtEmail.isUserInteractionEnabled = false
            self.txtPhone.text = info.phoneNumber
            self.setImageWithUrl(imageView: self.imgProfile, url: info.image, placeholderImage: AssetNames.Box_Blue)
        if info.email != "" {
            self.txtEmail.isUserInteractionEnabled = false
        }
        
    }
    
    //MARK: - CHANGE PASSWORD DELEGATE METHODS
    override func callBackActionSubmit(_ currentPassword: String, _ newPassword: String) {
        self.changePasswordApiCall(Params: [DictKeys.Current_Password: currentPassword,
                                            DictKeys.New_Password: newPassword])
    }
    
    override func callBackActionClosePopup() {
        self.alertView?.close()
    }
    
    
    //MARK: - IMAGE PICKER CONTROLLER DELEGATE METHODS
//    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        self.imgProfile.image = image
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    override func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        self.imgProfile.image = image
        // 'image' is the newly cropped version of the original image
    }
}

extension ProfileSettingViewController :  UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case txtFirstName:
            setUnderLineBGColor(view: fNameUnderLineView)
        case txtLastName:
            setUnderLineBGColor(view: lNameUnderLineView)
        case txtEmail:
            setUnderLineBGColor(view: emailUnderLineView)
        case txtPhone:
            setUnderLineBGColor(view: phoneUnderLineView)
        default:
            print("default not defined yet")
        }
    }
}

//MARK: - EXTENSION API CALLS
extension ProfileSettingViewController{
    func changePasswordApiCall(Params: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            LoginService.shared().changePasswordApi(params: Params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
                            self.alertView?.close()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    func ProfileUpdateApi(params: ParamsAny, imageData: [String: Data]?){
        self.startActivity()
        GCD.async(.Background) {
            LoginService.shared().profileUpdateApi(params: params, dict: imageData) { (message, success, json) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        
//                        self.showAlertView(message: message, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
//                            //self.loadHomeController()
//                            //self.navigationController?.popViewController(animated: true)
//                        }
                        self.showAlertView(message: message)
                        self.configureUserInfo()
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}

