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
    
    //MARK: - Vars, Objects
    
    var graphviewModel = GraphStatesListViewModel()
    var statesViewModel = StatesViewModel()
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.btnPlusShadow.dropShadow(radius: 3, opacity: 0.2)
        
        self.tabelView.register(UINib(nibName: CellIdentifier.PieChartTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.PieChartTableViewCell)
        self.tabelView.register(UINib(nibName: CellIdentifier.BarChartTableViewCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.BarChartTableViewCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getGraphStatesServerCall()
        self.getStatesServerCall()
        
        if let container = self.mainContainer{
            container.setMenuButton(false, title: TitleNames.Home,isTopBarWhite: false)
            self.setImageWithUrl(imageView: container.imgUser, url: Global.shared.user.image, placeholderImage: AssetNames.Box_Blue)
        }
    }
    
    
    //MARK: - IBACTION METHODS
    @IBAction func actionAddTask(_ sender: UIButton){
        
    }
    
    //MARK: - FUNCTIONS
    func moveToTaskListHistiryVC() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CheckListHistoryViewController) as! CheckListHistoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
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
            cell.statesViewModel = self.statesViewModel
            
            cell.viewCollection.reloadData()
            return cell
        }else{
            if(indexPath.row == 0){
                //            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TaskTypesTableViewCell) as! TaskTypesTableViewCell
                //            cell.ConfigureTypes(index: indexPath.row)
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.PieChartTableViewCell) as! PieChartTableViewCell

                cell.configureView()
                return cell
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.BarChartTableViewCell) as! BarChartTableViewCell
                
                cell.configureCell(info: self.graphviewModel)
        
                return cell
            }
            
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
            if(indexPath.row == 0){
                return 160
            }
            return 270
            
        }
    }
    
    //MARK: - DELEGATE METHODS
    func callBackMoveOnContoller(index: Int) {
        print(index)
        if index == 0{
            if Global.shared.user.loginType == LoginType.super_admin{
                let storyboard = UIStoryboard(name: StoryboardNames.Admin, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.AdminListViewController) as! AdminListViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.showAlertView(message: PopupMessages.youDontHavePermitonForTheFeature)
            }
            
        }else if index == 1{
            let storyboard = UIStoryboard(name: StoryboardNames.Admin, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.TechnicianListViewController) as! TechnicianListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else if index == 2 {
                            let storyboard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.CategoryListViewController) as! CategoryListViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                moveToTaskListHistiryVC()
            }
    }
}


extension HomeViewController {
    func getGraphStatesServerCall() {
        self.startActivity()
        GCD.async(.Background) {
            AdminTechnicianService.shared().getGraphStatesAPI(params: [:]) { (message, success, graphInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success{
                        if let graphData = graphInfo{
                            self.graphviewModel = graphData
                            
                            self.tabelView.reloadData()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    
    func getStatesServerCall() {
        self.startActivity()
        GCD.async(.Background) {
            AdminTechnicianService.shared().getStatesAPI(params: [:]) { (message, success, stateInfo) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success{
                        if let stateData = stateInfo{
                            self.statesViewModel = stateData
                            self.tabelView.reloadData()
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}
