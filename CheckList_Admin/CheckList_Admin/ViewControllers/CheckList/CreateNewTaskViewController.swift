//
//  CreateNewTaskViewController.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 02/07/2021.
//

import UIKit

class CreateNewTaskViewController: BaseViewController, TopBarDelegate{
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var taskTileTF: UITextField!
    @IBOutlet weak var isPriorityBtn: UIButton!
    @IBOutlet weak var ifNeededBtn: UIButton!
    
    @IBOutlet weak var descriptionTexView: KMPlaceholderTextView!
    
    //MARK: - Vars/ objects
    var categoryDetailObject = CategoryViewModel()
    var notApplicable = 0
    var isPriority = 0
    
    var subCatTaskObj : CategoryTaskViewModel?
    var subCatTaskQuestionsObj : CheckListQuestionViewModel?
    
    var ctegoryTaskViewModel = CategoryTaskViewModel()
    var checkListQuestionObjData : [CheckListQuestionViewModel] = []
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
            container.setMenuButton(true, title: TitleNames.CreateCheckList)
        }
    }
    
    //MARK: - functions
    
    func saveTaskList() {
        //var checkListQuestionObjData : [CheckListQuestionViewModel] = []
        checkListQuestionObjData.removeAll()
        for subCat in categoryDetailObject.subCategoryList {
            
            checkListQuestionObjData.append(CheckListQuestionViewModel(id: subCat.id, sub_category_name: subCat.subcategoryName, not_applicable: subCat.notApplicable, sub_category_description: subCat.subcategoryDescription, is_priority: subCat.isPriority))
        }
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

            checkListQuestionObjData.append(CheckListQuestionViewModel(id: 0, sub_category_name: taskTileTF.text!, not_applicable: notApplicable, sub_category_description: descriptionTexView.text!, is_priority: isPriority))
            
            self.showAlertView(message: PopupMessages.ChecklistCreated, title: "", doneButtonTitle: "Ok") { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }
//            self.createTaskServerCall(param: [DictKeys.Category_Id:categoryDetailObject.id, DictKeys.sub_category_name: taskTileTF.text!, DictKeys.not_applicable :  notApplicable, DictKeys.is_priority : isPriority  ])
        }
    }
}

extension CreateNewTaskViewController {
    
    //MARK: - Create Task API
    func createTaskServerCall(param: ParamsAny){
        self.startActivity()
        GCD.async(.Background) {
            CheckListService.shared().CreateNewTaskApi(params: param) { (message, success, info) in
                GCD.async(.Main) {
                    self.stopActivity()
                    
                    if success{
                        
                        if let subCategory = info{
                            self.categoryDetailObject.subCategoryList.append(subCategory)
                        }
                        
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
