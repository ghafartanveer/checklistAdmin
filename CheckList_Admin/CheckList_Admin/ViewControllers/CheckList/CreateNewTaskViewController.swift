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
    
    @IBOutlet weak var descriptionContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionTexView: KMPlaceholderTextView!
    @IBOutlet weak var descriptionTxtVContainer: UIView!
    
    @IBOutlet weak var notetxtVContainer: UIView!
    @IBOutlet weak var noteTxtView: KMPlaceholderTextView!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    //MARK: - Vars/ objects
    // var categoryDetailObject = CategoryViewModel()
    var categoryObj = CategoryViewModel()

    var notApplicable = 0
    var isPriority = 0
    
    var indexToAdit = -1
    
    var forAdit = false
    //MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if categoryObj.hasImages == 0 {
            descriptionTxtVContainer.isHidden = true
            descriptionContainerHeight.constant = 0
        } else {
            descriptionTxtVContainer.isHidden = false
            descriptionContainerHeight.constant = 130
        }
        
        //saveTaskList()
        if let container = self.mainContainer{
            container.delegate = self
            if indexToAdit >= 0 {
                //update Task
                saveBtn.setTitle(LocalStrings.update, for: .normal)
                container.setMenuButton(true, title: TitleNames.UpdateTask)
                configureTaskData()
            } else {
                //Add new task
                saveBtn.setTitle(LocalStrings.Save, for: .normal)
                container.setMenuButton(true, title: TitleNames.CreateCheckList)
            }
            
        }
    }
    
    //MARK: - functions
    
    func configureTaskData() {
        let tf = [false,true]
        taskTileTF.text = Global.shared.subCategoryList[indexToAdit].subcategoryName
        notApplicable = Global.shared.subCategoryList[indexToAdit].notApplicable
        isPriority = Global.shared.subCategoryList[indexToAdit].isPriority
        descriptionTexView.text = Global.shared.subCategoryList[indexToAdit].subcategoryDescription
        
        noteTxtView.text = Global.shared.subCategoryList[indexToAdit].note
        isPriorityBtn.isSelected = tf[isPriority]
        ifNeededBtn.isSelected = tf[notApplicable]
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
        } else if Global.shared.subCategoryList.contains(where: { $0.subcategoryName.caseInsensitiveCompare(self.taskTileTF.text!) == .orderedSame }) {
            if indexToAdit == -1 { // its for Add task
                print("contains is true")
                message = ValidationMessages.tasknameAlreadyExist
                isValid = false
            }
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
            
            if indexToAdit == -1 { // addTask
               
                let newTask = SubCategoryViewModel()
                
               
                newTask.subcategoryName = taskTileTF.text!
                newTask.notApplicable = notApplicable
                newTask.subcategoryDescription = descriptionTexView.text!
                newTask.note = noteTxtView.text!
                newTask.isPriority = isPriority
                
                Global.shared.subCategoryList.insert(newTask, at: 0)
                Global.shared.isSubCategoryListEdited = true
                self.showAlertView(message: PopupMessages.TaskAddedSuccessfully, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }
            } else { // update Task
               
                //let newTask = SubCategoryViewModel()
               
                //newTask.subcategoryName = taskTileTF.text!
                //newTask.notApplicable = notApplicable
                //newTask.subcategoryDescription = descriptionTexView.text!
                //newTask.isPriority = isPriority
                //subCategoryList.append(newTask)
                Global.shared.subCategoryList[indexToAdit].isPriority = self.isPriority
                Global.shared.subCategoryList[indexToAdit].notApplicable = self.notApplicable
                Global.shared.subCategoryList[indexToAdit].subcategoryName = taskTileTF.text!
                Global.shared.subCategoryList[indexToAdit].subcategoryDescription =  descriptionTexView.text!
                Global.shared.subCategoryList[indexToAdit].note =  noteTxtView.text!
                //subCategoryList.insert(newTask, at: 0)
                Global.shared.isSubCategoryListEdited = true
                
                self.showAlertView(message: PopupMessages.TaskUpdatedSuccessfully, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
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
