//
//  AddCategoryViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 06/05/2021.
//

import UIKit

class AddCategoryViewController: BaseViewController, TopBarDelegate{
    //MARK: - IBOUTLETS
    @IBOutlet weak var txtCategoryName: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnAddImages: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    
    //MARK: - OBJECT AND VERIBALES
    var isForUpdate: Bool = false
    var categoryObj: CategoryViewModel?
    var categoryID: Int = 0
    var addImages: Int = 0
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCategory()
        self.setupAuthObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            if self.isForUpdate{
                container.setMenuButton(true, title: TitleNames.Update_Category)
            }else{
                container.setMenuButton(true, title: TitleNames.Add_Category)
            }
            
        }
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionSave(_ sender: UIButton){
        if !self.txtCategoryName.text!.isEmpty{
            if self.isForUpdate{
                self.updateCategoryApi()
            }else{
                
                self.addCategoryApi()
            }
        }
    }
    
    @IBAction func actionAddImages(_ sender: UIButton){
        if self.btnAddImages.isSelected{
            self.btnAddImages.isSelected = false
            self.addImages = 0
            
        }else{
            self.btnAddImages.isSelected = true
            self.addImages = 1
        }
    }
    
    //MARK: - FUNCTION
    func configureCategory(){
        if self.isForUpdate{
            if let obj = self.categoryObj{
                self.txtCategoryName.text = obj.name
                self.categoryID = obj.id
                if obj.hasImages == 1{
                    self.addImages = 1
                    self.btnAddImages.isSelected = true
                }
            }
            self.lblMainTitle.text = "Please update your Category"
            self.btnSave.setTitle("Update", for: .normal)
        }
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - EXTENSION API CALLS
extension AddCategoryViewController{
    
    func addCategoryApi(){
        let param: ParamsAny = [DictKeys.name: self.txtCategoryName.text!,
                                DictKeys.hasImages: self.addImages]
        self.startActivity()
        GCD.async(.Background) {
            StoreCategoryService.shared().addCategoryApi(params: param) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: LocalStrings.success, doneButtonTitle: LocalStrings.ok) { (UIAlertAction) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    func updateCategoryApi(){
        let param: ParamsAny = [DictKeys.name: self.txtCategoryName.text!,
                                DictKeys.Category_Id: self.categoryID,
                                DictKeys.hasImages: self.addImages]
        self.startActivity()
        GCD.async(.Background) {
            StoreCategoryService.shared().updateCategoryApi(params: param) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        self.showAlertView(message: message, title: LocalStrings.success, doneButtonTitle: LocalStrings.ok) { (UIAlertAction) in
                            self.navigationController?.popViewController(animated: true)
                        }                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
   
}
