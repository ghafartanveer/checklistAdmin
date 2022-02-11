//
//  AddStoreViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 06/05/2021.
//

import UIKit

class AddStoreViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var txtStoreName: UITextField!
    @IBOutlet weak var txtStoreAddress: UITextView!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    
    @IBOutlet weak var adressBtn: UIButton!
    
    //MARK: - OBJECT AND VERIBALES
    var isFromEditStore = false
    var storeObj = StoreViewModel()
    
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureStoreDetail()

        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Add_Store)
        }
    }
    
    //MARK: - IBACTION METHODS
   
    @IBAction func mapBtnAction(_ sender: Any) {
        navigateToMapVC()
    }
    
    
    @IBAction func actionSaveStore(_ sender: UIButton){
        if checkValidation(){
            if self.isFromEditStore{
                self.updateStoreApi(Params: [DictKeys.name: self.txtStoreName.text!,
                                          DictKeys.address: self.txtStoreAddress.text!,
                                          DictKeys.Store_Id: self.storeObj.id ?? 0,
                                          DictKeys.state: stateTF.text!,
                                          DictKeys.zip_code: zipCodeTF.text ?? "",])
            }else{
                self.addStoreApi(Params: [DictKeys.name: self.txtStoreName.text!,
                                          DictKeys.address: self.txtStoreAddress.text!,
                                          DictKeys.city: self.txtCity.text!,
                                          DictKeys.state: stateTF.text!,
                                          DictKeys.zip_code: zipCodeTF.text ?? ""
                ])
            }
            
        }
    }
    
    
    //MARK: - FUNCTIONS
    func configureStoreDetail(){
        //if self.isFromEditStore{
             let obj = self.storeObj
                self.txtStoreName.text = obj.name
                self.txtStoreAddress.text = obj.address
                self.txtCity.text = obj.city
                self.stateTF.text = obj.state
                self.zipCodeTF.text = obj.zip_code
            
        //}
    }
    
    func checkValidation() -> Bool{
        var message = ""
        var isValid: Bool = true
        
        let isCityNameValid = Validations.CityNameValidation(txtCity.text!)
        
        if self.txtStoreName.text!.isEmpty{
            message = ValidationMessages.Empty_Store_Name
            isValid = false
            
        }else if self.txtStoreAddress.text!.isEmpty{
            message = ValidationMessages.Empty_Store_Address
            isValid = false
            
        }else if self.txtCity.text!.isEmpty{
            message = ValidationMessages.Empty_City_Name
            isValid = false
            
        }  else if self.stateTF.text!.isEmpty{
            message = ValidationMessages.Empty_State_Name
            isValid = false
            
        }
//        else if self.zipCodeTF.text!.isEmpty{
//            message = ValidationMessages.Empty_ZipCode_Name
//            isValid = false
//        }
        
        else if !isCityNameValid.isValid {
            message = isCityNameValid.message
            isValid = false
        }
        
    
        if !isValid{
            self.showAlertView(message: message)
        }
        return isValid
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigateToMapVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.MapPlacesViewController) as! MapPlacesViewController
        vc.storemodel = self.storeObj ?? StoreViewModel()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - EXTENSION API CALLS
extension AddStoreViewController{
    func addStoreApi(Params: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            StoreCategoryService.shared().addStoreApi(params: Params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    func updateStoreApi(Params: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            StoreCategoryService.shared().updateStoreApi(params: Params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
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

//extension AddStoreViewController : MapPlacesViewControllerDelegate {
//    func updateAdress(address: String, zipCode: String, isFromMap: Bool) {
//        print("adress selected")
//    }
//}
