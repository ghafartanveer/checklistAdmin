//
//  ImagesViewModel.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/05/2021.
//

import Foundation
import SwiftyJSON


class ImagesViewModel{
    
    var categoryId: Int
    var Id: Int
    var createdAt: String
    var image: String
    var typeName: String
    var updatedAt: String
    
    
    init() {
        self.categoryId = 0
        self.Id = 0
        self.createdAt = ""
        self.image = ""
        self.typeName = ""
        self.updatedAt = ""
    }
    
    
    
    init(obj: JSON) {
        self.categoryId = obj["category_id"].int ?? 0
        self.Id = obj["id"].int ?? 0
        self.createdAt = obj["created_at"].string ?? ""
        self.image = obj["image"].string ?? ""
        self.typeName = obj["type_name"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
       
    }
}
