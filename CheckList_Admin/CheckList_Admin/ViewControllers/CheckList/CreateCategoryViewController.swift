//
//  CreateCategoryViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/05/2021.
//

import UIKit

class CreateCategoryViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewTxtShadow: UIView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var viewTabel: UITableView!
    @IBOutlet weak var viewTabelList: UITableView!
    @IBOutlet weak var viewTabelHeight: NSLayoutConstraint!
    
    //MARK: - OBJECT AND VERIBALES
    var categoryObj = CategoryListViewModel()
    var subCategoryList = [SubCategoryViewModel]()
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewTxtShadow.dropShadow(radius: 4, opacity: 0.3)
        self.viewTabelHeight.constant = 0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtTitle.text = self.categoryObj.categoryList[0].name
        self.subCategoryList = self.categoryObj.categoryList[0].subCategoryList
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Create_Check_List)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.viewTabelHeight.constant = 0
    }

    //MARK: - IBACTION METHODS
    
    @IBAction func hideList(_ sender: Any) {
        self.viewTabelHeight.constant = 0
    }
    
    @IBAction func actionAddCategory(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.AddCategoryViewController) as! AddCategoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionAddSubCategory(_ sender: UIButton){
        let storyboard = UIStoryboard(name: StoryboardNames.Category, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.CreateSubCategoryViewController) as! CreateSubCategoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionOpenCategoryList(_ sender: UIButton){
        self.viewTabelHeight.constant = 200
    }
    
    @IBAction func actionSubmit(_ sender: UIButton){
        
    }
    
    //MARK: - FUNCTIONS
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureTabelViewList(){
        if self.categoryObj.categoryList.count > 0{
            self.viewTabelList.reloadData()
        }
    }
    
}
//MARK: - EXTENSION TABEL VIEW METHODS
extension CreateCategoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.viewTabelList{
            return self.categoryObj.categoryList.count
        }else{
            return self.subCategoryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.viewTabelList{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CategoryDropDownTableViewCell) as! CategoryDropDownTableViewCell
            cell.lblName.text = self.categoryObj.categoryList[indexPath.row].name
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CreateSubCategoryTableViewCell) as! CreateSubCategoryTableViewCell
            cell.configureSubCategory(info: self.subCategoryList[indexPath.row])
            cell.viewShadow.dropShadow(radius: 5, opacity: 0.4)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == viewTabelList {
        self.txtTitle.text = self.categoryObj.categoryList[indexPath.row].name
        
        
        self.subCategoryList = self.categoryObj.categoryList[indexPath.row].subCategoryList
        self.viewTabel.reloadData()
        }
        self.viewTabelHeight.constant = 0
               
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.viewTabelList{
            return 30
        }else{
            return 120
        }
        
    }
    
}
//MARK: - EXTENSION API CALLS
extension CreateCategoryViewController{
    func getCategoryListApi(){
        self.startActivity()
        GCD.async(.Background) {
            StoreCategoryService.shared().categoryListApi(params: [:]) { (message, success, catInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success{
                        if let category = catInfo{
                            self.categoryObj = category
                            self.viewTabelList.reloadData()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}
