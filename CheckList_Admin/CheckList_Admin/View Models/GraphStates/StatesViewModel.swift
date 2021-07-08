//
//  StatesViewModel.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 07/07/2021.
//

import Foundation
import SwiftyJSON

class StatesViewModel {
    
    var admins: Int
    var technicians: Int
    var checklists: Int
    var completedTask: Int
    
    init() {
        self.admins = 0
        self.technicians = 0
        self.checklists = 0
        self.completedTask = 0
    }
    init(obj: JSON) {
        self.admins = obj["admins"].int ?? 0
        self.technicians = obj["technicians"].int ?? 0
        self.checklists = obj["checklists"].int ?? 0
        self.completedTask = obj["completed_task"].int ?? 0
    }
}
