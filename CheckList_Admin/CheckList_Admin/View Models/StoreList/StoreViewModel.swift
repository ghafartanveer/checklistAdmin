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
    var state: String
    var zip_code: String
    var deletedAt: String
    var createdAt: String
    var updatedAt: String
    var storeAdmin = AdminViewModel()
    var storeTechnitian = AdminListViewModel()
    init() {
        self.id = 0
        self.name = ""
        self.address = ""
        self.city = ""
        self.state = ""
        self.zip_code = ""
        self.deletedAt = ""
        self.createdAt = ""
        self.updatedAt = ""
        self.storeAdmin = AdminViewModel()
        self.storeTechnitian = AdminListViewModel()
    }
    
    
    init(obj: JSON) {
        self.id = obj["id"].int ?? 0
        self.name = obj["name"].string ?? ""
        self.address = obj["address"].string ?? ""
        self.city = obj["city"].string ?? ""
        self.state = obj["state"].string ?? ""
        self.zip_code = obj["zip_code"].string ?? ""
        self.deletedAt = obj["deleted_at"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
        self.storeAdmin = AdminViewModel(obj: obj["admin"])
        self.storeTechnitian = AdminListViewModel(list: obj["technician"])
        
        
    }
}



