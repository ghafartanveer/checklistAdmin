//
//  StoreViewModel.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 06/05/2021.
//

import Foundation
import SwiftyJSON


class StoreViewModel {
    
    var id: Int
    var name: String
    var address: String
    var city: String
    var deletedAt: String
    var createdAt: String
    var updatedAt: String
    
    init() {
        self.id = 0
        self.name = ""
        self.address = ""
        self.city = ""
        self.deletedAt = ""
        self.createdAt = ""
        self.updatedAt = ""
    }
    
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.name = obj["name"].string ?? ""
        self.address = obj["address"].string ?? ""
        self.city = obj["city"].string ?? ""
        self.deletedAt = obj["deleted_at"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
        
    }
}



