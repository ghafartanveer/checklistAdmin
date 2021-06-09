//
//  ChangePasswordViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 06/05/2021.
//

import UIKit

protocol ChangePasswordPopUpViewControllerDelegate: NSObjectProtocol {
    func callBackActionSubmit(_ currentPassword: String, _ newPassword: String)
    func callBackActionClosePopup()
}

class ChangePasswordPopUpViewController: BaseViewController {
    //MARK: - IBOUTLETS
    @IBOutlet weak var txtCurrentPssword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    
    //MARK: - OBJECT AND VERIABLES
    weak var delegate: ChangePasswordPopUpViewControllerDelegate?
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - IBACTION METHODS
    @IBAction func actionSubmit(_ sender: UIButton){
        if self.checkValidations(){
            delegate?.callBackActionSubmit(self.txtCurrentPssword.text!, self.txtNewPassword.text!)
        }
       
    }
    
    @IBAction func actionClose(_ sender: UIButton){
        delegate?.callBackActionClosePopup()
    }
     
    //MARK: - FUNCTIONS
    func checkValidations() -> Bool{
        var isValid: Bool = true
        let validCurrentPassword = Validations.passwordValidation(self.txtCurrentPssword.text!)
        let validNewPassword = Validations.passwordValidation(self.txtNewPassword.text!)
        
        if !validCurrentPassword.isValid{
            self.showAlertView(message: validCurrentPassword.message)
            isValid = false
        }else if !validNewPassword.isValid{
            self.showAlertView(message: validNewPassword.message)
            isValid = false
        }
        return isValid
    }
    
    
}
