//
//  SubCategoryViewModel.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/05/2021.
//

import Foundation
import SwiftyJSON


class SubCategoryViewModel {
    var id: Int
    var categoryId: Int
    var notApplicable: Int
    var no: Int
    var yes: Int
    var isPriority: Int
    var deletedAt: String
    var updatedAt: String
    var subcategoryName: String
    var createdAt: String
    var subcategoryDescription: String
    
    init() {
        self.id = 0
        self.categoryId = 0
        self.notApplicable = 0
        self.no = 0
        self.yes = 0
        self.isPriority = 0
        self.deletedAt = ""
        self.updatedAt = ""
        self.subcategoryName = ""
        self.createdAt = ""
        self.subcategoryDescription = ""
    }
    
    init(obj: JSON) {
        
        self.id = obj["id"].int ?? 0
        self.categoryId = obj["category_id"].int ?? 0
        self.notApplicable = obj["not_applicable"].int ?? 0
        self.no = obj["no"].int ?? 0
        self.yes = obj["yes"].int ?? 0
        self.isPriority = obj["is_priority"].int ?? 0
        self.deletedAt = obj["deleted_at"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
        self.subcategoryName = obj["subcategory_name"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
        self.subcategoryDescription = obj["subcategory_description"].string ?? ""
    }
}
          
