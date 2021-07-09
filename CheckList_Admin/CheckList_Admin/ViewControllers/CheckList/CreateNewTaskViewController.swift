//
//  CreateNewTaskViewController.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 02/07/2021.
//

import UIKit
//subCategoryList
class CreateNewTaskViewController: BaseViewController, TopBarDelegate{
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var taskTileTF: UITextField!
    @IBOutlet weak var isPriorityBtn: UIButton!
    @IBOutlet weak var ifNeededBtn: UIButton!
    
    @IBOutlet weak var descriptionTexView: KMPlaceholderTextView!
    
    //MARK: - Vars/ objects
    // var categoryDetailObject = CategoryViewModel()
    var notApplicable = 0
    var isPriority = 0
    
    var indexToAdit = -1
    
    //MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //saveTaskList()
        if let container = self.mainContainer{
            container.delegate = self
            if indexToAdit >= 0 {
                //update Task
                container.setMenuButton(true, title: TitleNames.UpdateTask)
                configureTaskData()
            } else {
                //Add nw task
                container.setMenuButton(true, title: TitleNames.CreateCheckList)
            }
            
        }
    }
    
    //MARK: - functions
    
    func configureTaskData() {
        taskTileTF.text = subCategoryList[indexToAdit].subcategoryName
        notApplicable = subCategoryList[indexToAdit].notApplicable
        isPriority = subCategoryList[indexToAdit].isPriority
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    func checkValidation() -> Bool{
        var message = ""
        var isValid: Bool = true
        
        if self.taskTileTF.text!.isEmpty{
            message = ValidationMessages.taskName
            isValid = false
        }
        
        if !isValid{
            self.showAlertView(message: message)
        }
        return isValid
    }
    
    @IBAction func markAsPriorityAction(_ sender: Any) {
        if isPriorityBtn.isSelected {
            isPriorityBtn.isSelected = false
            isPriority = 0
        } else {
            isPriorityBtn.isSelected = true
            isPriority = 1
        }
        
    }
    
    @IBAction func ifNeededAction(_ sender: Any) {
        if ifNeededBtn.isSelected {
            ifNeededBtn.isSelected = false
            notApplicable = 0
        } else {
            ifNeededBtn.isSelected = true
            notApplicable = 1
        }
    }
    
    @IBAction func saveTaskAction(_ sender: Any) {
        if self.checkValidation() {
            
            if indexToAdit == -1 {
                let newTask = SubCategoryViewModel()
                //            checkListQuestionObjData.append(CheckListQuestionViewModel(id: 0, sub_category_name: taskTileTF.text!, not_applicable: notApplicable, sub_category_description: descriptionTexView.text!, is_priority: isPriority))
                newTask.subcategoryName = taskTileTF.text!
                newTask.notApplicable = notApplicable
                newTask.subcategoryDescription = descriptionTexView.text!
                newTask.isPriority = isPriority
                //subCategoryList.append(newTask)
                
                subCategoryList.insert(newTask, at: 0)
                Global.shared.isSubCategoryListEdited = true
                self.showAlertView(message: PopupMessages.ChecklistCreated, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                subCategoryList[indexToAdit].subcategoryName = self.taskTileTF.text!
                subCategoryList[indexToAdit].notApplicable = notApplicable
                subCategoryList[indexToAdit].isPriority = isPriority
                
                self.showAlertView(message: PopupMessages.ChecklistUpdated, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension CreateNewTaskViewController {
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
