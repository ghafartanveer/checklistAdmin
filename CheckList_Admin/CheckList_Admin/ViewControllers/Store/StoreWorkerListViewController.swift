//
//  StoreWorkerListViewController.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmed on 16/11/2021.
//

import UIKit

class StoreWorkerListViewController: BaseViewController,TopBarDelegate {
    var isFont = false
    var store = StoreViewModel()
    @IBOutlet weak var workerListtV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: "Store Wrker List", isTopBarWhite: true)
        }
        workerListtV.delegate = self
        workerListtV.dataSource = self
    }
    
    func actionBack() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension StoreWorkerListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
       switch(section) {
         case 0:return "Admin"
         case 1: return "Technician"
         default :return ""

       }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if store.storeAdmin.id > 0 {
                return 1
            } else {
                return 0
            }
        } else {
            return store.storeTechnitian.adminList.count //self.technicianObject.adminList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TechnicianDetailTableViewCell) as! TechnicianDetailTableViewCell
        
        if indexPath.section == 0 {
            cell.configureTechnician(info: store.storeAdmin)
        } else {
            cell.configureTechnician(info: store.storeTechnitian.adminList[indexPath.row])
        }
        cell.shadowView.dropShadow(radius: 5, opacity: 0.4)
        cell.userImageView.cornerRadius = cell.userImageView.frame.width/2
        // print(cell.userImageView.frame.width/2)
        cell.userImageView.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
