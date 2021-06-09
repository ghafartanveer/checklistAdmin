//
//  HomeViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 27/04/2021.
//

import UIKit

class HomeViewController: BaseViewController {
    //MARK: - IBOUTLETS
    @IBOutlet weak var btnPlusShadow: UIButton!
    @IBOutlet weak var tabelView: UITableView!
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.btnPlusShadow.dropShadow(radius: 3, opacity: 0.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.setMenuButton(false, title: TitleNames.Home)
            self.setImageWithUrl(imageView: container.imgUser, url: Global.shared.user.image, placeholderImage: AssetNames.Box_Blue)
        }
    }
    
    
    //MARK: - IBACTION METHODS
    @IBAction func actionAddTask(_ sender: UIButton){
        
    }
    
    //MARK: - FUNCTIONS
    
}
//MARK: - EXTENSION TABEL VIEW METHODS
extension HomeViewController: UITableViewDelegate, UITableViewDataSource, TaskCategoryTableViewCellDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TaskCategoryTableViewCell) as! TaskCategoryTableViewCell
            cell.delegate = self
            cell.viewCollection.reloadData()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TaskTypesTableViewCell) as! TaskTypesTableViewCell
            cell.ConfigureTypes(index: indexPath.row)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //                let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.WorkListViewController) as! WorkListViewController
        //                self.navigationController?.pushViewController(vc, animated: true)
        //            }
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 420
            
        }else{
            return 80
        }
    }
    
    //MARK: - DELEGATE METHODS
    func callBackMoveOnContoller(index: Int) {
        
        if index == 0{
            if Global.shared.user.loginType == LoginType.super_admin{
                let storyboard = UIStoryboard(name: StoryboardNames.Admin, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.AdminListViewController) as! AdminListViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if index == 1{
            let storyboard = UIStoryboard(name: StoryboardNames.Admin, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.TechnicianListViewController) as! TechnicianListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let storyboard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.CategoryListViewController) as! CategoryListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}
