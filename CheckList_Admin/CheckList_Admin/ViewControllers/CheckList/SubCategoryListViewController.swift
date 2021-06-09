//
//  CreateCheckListViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 27/04/2021.
//

import UIKit

class SubCategoryListViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    
    
    //MARK: - OBJECT AND VERIBALES
    var subCategoryList = [SubCategoryViewModel]()
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAuthObserver()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: TitleNames.Create_Check_List)
        }
    }
    
    //MARK: - FUNCTIONS
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - EXTENSION TABEL VIEW METHODS
extension SubCategoryListViewController: UITableViewDelegate, UITableViewDataSource, SubCategoryListTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.subCategoryList.count > 0{
            return self.subCategoryList.count
        }else{
            self.showAlertView(message: "No subcategory list found")
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SubCategoryListTableViewCell) as! SubCategoryListTableViewCell
        cell.configureSubCategory(info: self.subCategoryList[indexPath.row])
        cell.delegate = self
        cell.viewShadow.dropShadow(radius: 5, opacity: 0.4)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        //                let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.WorkListViewController) as! WorkListViewController
        //                self.navigationController?.pushViewController(vc, animated: true)
        //            }
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
    
    //MARK: - DELEGATE METHODS
    func callBackActionMarkPriority(index: Int) {
        print(index)
    }
    func callBackActionNotAvailable(index: Int) {
        print(index)
    }
}
