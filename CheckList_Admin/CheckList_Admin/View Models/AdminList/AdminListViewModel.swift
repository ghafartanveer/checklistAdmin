//
//  AdminListViewModel.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 05/05/2021.
//

import Foundation
import SwiftyJSON

class AdminListViewModel {
    var adminList: [AdminViewModel]
    
    init() {
        self.adminList = [AdminViewModel]()
    }
    
    convenience init(list: JSON) {
        self.init()
        
        if let jsonList = list.array{
          let list = jsonList.map({AdminViewModel(obj: $0)})
            self.adminList.append(contentsOf: list)
        }
    }
    
    
    func getAdminDetailAganistID(AdminID: Int) -> AdminViewModel{
        var adminDetail = AdminViewModel()
        for each in self.adminList{
            if each.id == AdminID{
                adminDetail = each
            }
        }
        return adminDetail
    }
}
