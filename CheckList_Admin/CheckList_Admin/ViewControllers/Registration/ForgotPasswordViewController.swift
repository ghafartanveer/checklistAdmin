//
//  ForgotPasswordViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 11/05/2021.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    //MARK: - IBOUTLETS
    @IBOutlet weak var txtEmail: UITextField!
    
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionSendInstructions(_ sender: UIButton){
        let emailValidation = Validations.emailValidation(self.txtEmail.text!)
        if emailValidation.isValid{
            self.forgotPasswordApiCall(Params: [DictKeys.email: self.txtEmail.text!])
        }else{
            self.showAlertView(message: emailValidation.message)
        }
    }
    
    @IBAction func actionBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - FUNCTIONS
    func moveToUpdatePasswordVC(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.UpdatePasswordViewController) as! UpdatePasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - EXTENSION API CALLS
extension ForgotPasswordViewController{
    func forgotPasswordApiCall(Params: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            LoginService.shared().forgetPassword(params: Params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
                            self.moveToUpdatePasswordVC()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}


