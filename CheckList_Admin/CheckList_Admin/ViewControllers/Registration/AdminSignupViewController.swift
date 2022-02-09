//
//  AdminSignupViewController.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmed on 16/11/2021.
//

import UIKit
import CropViewController

class AdminSignupViewController: BaseViewController {
    //MARK: - IBOUTETS

    @IBOutlet weak var viewImgShadow: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var mobileShadowView: UIView!
    @IBOutlet weak var mobileNumberTF: UITextField!

    @IBOutlet weak var storeNameShadowView: UIView!
    @IBOutlet weak var storeNameTF: UITextField!
    
    @IBOutlet weak var storeAdresShadowView: UIView!
    @IBOutlet weak var storeAddressTF: UITextView!
    
    @IBOutlet weak var cityShadowV: UIView!
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var stateShadowV: UIView!
    @IBOutlet weak var stateTF: UITextField!
    
    @IBOutlet weak var zipShadowV: UIView!
    @IBOutlet weak var zipcodeTF: UITextField!
    
    @IBOutlet weak var emailShadoView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordShadowView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordShadowView: UIView!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    var isImageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDropShadow()
    }
    
    
    func configureDropShadow(){
        self.firstNameTF.dropShadow(radius: 4, opacity: 0.3)
        self.lastNameTF.dropShadow(radius: 4, opacity: 0.3)
        self.storeNameShadowView.dropShadow(radius: 4, opacity: 0.3)
        self.storeAdresShadowView.dropShadow(radius: 4, opacity: 0.3)
        self.mobileShadowView.dropShadow(radius: 4, opacity: 0.3)
        self.emailShadoView.dropShadow(radius: 4, opacity: 0.3)
        self.passwordShadowView.dropShadow(radius: 4, opacity: 0.3)
        self.confirmPasswordShadowView.dropShadow(radius: 4, opacity: 0.3)
        self.viewImgShadow.dropShadow(radius: 4, opacity: 0.5)
        viewImgShadow.dropShadow(radius: 4, opacity: 0.5)
        cityShadowV.dropShadow(radius: 4, opacity: 0.5)
        stateShadowV.dropShadow(radius: 4, opacity: 0.5)
        zipShadowV.dropShadow(radius: 4, opacity: 0.5)
        self.viewImgShadow.cornerRadius = viewImgShadow.frame.height/2
        self.viewImgShadow.clipsToBounds = true
    }
    
    func checkValidation() -> Bool{
        var message = ""
        var isValid: Bool = true
        let isValidEmail = Validations.emailValidation(self.emailTF.text!)
        let isValidPassword = Validations.passwordValidation(self.passwordTF.text!)
        let isValidRePassword = Validations.confirmPasswordValidation(self.passwordTF.text!, repeat: self.confirmPasswordTF.text!)
        let isPhoneValid = Validations.phoneNumberValidation(mobileNumberTF.text!)
        
        if self.firstNameTF.text!.isEmpty{
            message = ValidationMessages.Empty_First_Name
            isValid = false
            
        } else if self.lastNameTF.text!.isEmpty{
            message = ValidationMessages.Empty_Last_Name
            isValid = false
            
        } else if self.mobileNumberTF.text!.isEmpty{
            message = ValidationMessages.emptyPhonNumber
            isValid = false
            
        } else if !isPhoneValid.isValid {
            message = isPhoneValid.message //ValidationMessages.enterAValidPhone
            isValid = false
        } else if !isValidEmail.isValid{
            message = isValidEmail.message
            isValid = false
            
        } else if self.storeNameTF.text!.isEmpty{
            message = ValidationMessages.Empty_Store_Name
            isValid = false
            
        } else if self.storeAddressTF.text!.isEmpty{
            message = ValidationMessages.Empty_Store_Address
            isValid = false
        } else if self.cityTF.text!.isEmpty{
            message = ValidationMessages.Empty_City_Name
            isValid = false
            
        } else if self.stateTF.text!.isEmpty{
            message = ValidationMessages.Empty_State_Name
            isValid = false
            
        } else if self.zipcodeTF.text!.isEmpty{
            message = ValidationMessages.Empty_ZipCode_Name
            isValid = false
            
        } else if !isValidPassword.isValid{
                message = isValidPassword.message
                isValid = false
        } else if !isValidRePassword.isValid {
            message = isValidRePassword.message
            isValid = false
           }
        
        if !isValid{
            self.showAlertView(message: message)
        }
        return isValid
    }
    
    override func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        self.userImageView.image = image
        self.isImageSelected = true
        // 'image' is the newly cropped version of the original image
    }
    

    
    @IBAction func actionAddPhoto(_ sender: UIButton){
        self.fetchProfileImage()
    }
    
    @IBAction func backAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if checkValidation() {
                var imageData: [String: Data]?
                
                
                if self.isImageSelected{
                    imageData = [DictKeys.image: self.userImageView.image!.jpegData(compressionQuality: 0.50)!]
                }
                let params: ParamsAny = [DictKeys.first_name: self.firstNameTF.text!,
                                         DictKeys.last_name: self.lastNameTF.text!,
                                         DictKeys.email: self.emailTF.text!,
                                         DictKeys.store_name: self.storeNameTF.text!,
                                         DictKeys.store_address: self.storeAddressTF.text!,
                                         DictKeys.phone_number: self.mobileNumberTF.text!,
                                         DictKeys.password: self.passwordTF.text!,
                                         DictKeys.login_type: LoginType.Admin,
                                         DictKeys.is_admin: 0,
                                         DictKeys.city: cityTF.text!,
                                         DictKeys.state: stateTF.text!,
                                         DictKeys.zip_code: zipcodeTF.text!,
                                         DictKeys.is_payable: 1
                ]
             
                    self.addAdminApi(params: params, imageData: imageData)
                
            }

        }
    
}

extension AdminSignupViewController {
    func addAdminApi(params: ParamsAny, imageData: [String: Data]?){
        self.startActivity()
        GCD.async(.Background) {
            AdminTechnicianService.shared().registerAdminAndTechnicianApi(params: params, dict: imageData) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        var msg = ""
                        msg = PopupMessages.AdminAddedSuccess
                        
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

}
