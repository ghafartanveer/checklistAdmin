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
    
    @IBOutlet weak var cpView: UIView!
    @IBOutlet weak var npView: UIView!
    
    
    //MARK: - OBJECT AND VERIABLES
    weak var delegate: ChangePasswordPopUpViewControllerDelegate?
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtCurrentPssword.delegate = self
        txtNewPassword.delegate = self
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
     
   // MARK: - FUNCTIONS
    func setUnderLineBGColor(view: UIView) {
        
        let inativeBottomLinecolor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        cpView.backgroundColor = inativeBottomLinecolor
        npView.backgroundColor = inativeBottomLinecolor
       
        view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.3450980392, blue: 0.3960784314, alpha: 1)
    }
    
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

extension ChangePasswordPopUpViewController :  UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case txtCurrentPssword:
            setUnderLineBGColor(view: cpView)
        case txtNewPassword:
            setUnderLineBGColor(view: npView)
       
        default:
            print("default not defined yet")
        }
    }
}
