//
//  GraphStatesViewModel.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 06/07/2021.
//

import Foundation
import SwiftyJSON

// MARK: - GraphStatesViewModel
class GraphStatesViewModel {
    let technician, admin, checklist: Int
    let dayName: String
    let dayId : Int
    init() {
        
        self.technician = 0
        self.admin = 0
        self.checklist = 0
        self.dayName = ""
        self.dayId = 0
    }
    init(info: JSON, dayName: String) {
        self.technician = info["technician"].int ?? 0
        self.admin = info["admin"].int ?? 0
        self.checklist = info["checklist"].int ?? 0
        self.dayName = dayName
        self.dayId = info["key"].int ?? 0
    }
}



