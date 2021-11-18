//
//  CreateSubCategoryViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/05/2021.
//

import UIKit

class CreateSubCategoryViewController: BaseViewController, TopBarDelegate {
    
    
    
    @IBOutlet weak var btnPriority: UIButton!
    @IBOutlet weak var btnNotAvailable: UIButton!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var viewImageDespHeight: NSLayoutConstraint!
    
   // @IBOutlet weak var descriptionTextView: KMPlaceholderTextView!
    
    @IBOutlet weak var notesTextView: KMPlaceholderTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.createTask)
        }

    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionPriority(_ sender: UIButton){
        if self.btnPriority.isSelected{
            self.btnPriority.isSelected = false
        }else{
            self.btnPriority.isSelected = true
        }
    }
    
    @IBAction func actionNotAvailable(_ sender: UIButton){
        if self.btnNotAvailable.isSelected{
            self.btnNotAvailable.isSelected = false
        }else{
            self.btnNotAvailable.isSelected = true
        }
    }
    
    @IBAction func submitTaskubcat(_ sender: Any) {
        
    }
    
    //MARK: - Functions
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
   
}

extension CreateSubCategoryViewController {
    //            self.createTaskServerCall(param: [DictKeys.Category_Id:categoryDetailObject.id, DictKeys.sub_category_name: taskTileTF.text!, DictKeys.not_applicable :  notApplicable, DictKeys.is_priority : isPriority  ])
    
    //MARK: - Create Task API
    
    //    func createTaskServerCall(param: ParamsAny){
    //        self.startActivity()
    //        GCD.async(.Background) {
    //            CheckListService.shared().CreateNewTaskApi(params: param) { (message, success, info) in
    //                GCD.async(.Main) {
    //                    self.stopActivity()
    //
    //                    if success{
    //
    //                        if let subCategory = info{
    //                            subCategoryList.append(subCategory)
    //                            //self.categoryDetailObject.subCategoryList.append(subCategory)
    //                        }
    //
    //                        self.showAlertView(message: message, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
    //                            self.navigationController?.popViewController(animated: true)
    //                        }
    //                    }else{
    //                        self.showAlertView(message: message)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
}
