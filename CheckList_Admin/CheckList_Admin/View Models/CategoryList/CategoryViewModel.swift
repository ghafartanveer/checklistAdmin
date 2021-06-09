//
//  CategoryViewModel.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 06/05/2021.
//

import Foundation
import SwiftyJSON


class CategoryViewModel {
    
    var id: Int
    var hasImages: Int
    var name: String
    var deletedAt: String
    var createdAt: String
    var updatedAt: String
    var imagesList: [ImagesViewModel]
    var subCategoryList: [SubCategoryViewModel]
    
    
    init() {
        self.id = 0
        self.hasImages = 0
        self.name = ""
        self.deletedAt = ""
        self.createdAt = ""
        self.updatedAt = ""
        self.imagesList = [ImagesViewModel]()
        self.subCategoryList = [SubCategoryViewModel]()
    }
    
    
    convenience init(obj: JSON) {
        self.init()
        self.id = obj["id"].int ?? 0
        self.hasImages = obj["has_images"].int ?? 0
        self.name = obj["name"].string ?? ""
        self.deletedAt = obj["deleted_at"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
        self.updatedAt = obj["updated_at"].string ?? ""
        
        
        if let jsonList = obj["images"].array{
            let list = jsonList.map({ImagesViewModel(obj: $0)})
            self.imagesList.append(contentsOf: list)
        }
        if let jsonList = obj["subcategories"].array{
            let list = jsonList.map({SubCategoryViewModel(obj: $0)})
            self.subCategoryList.append(contentsOf: list)
        }
    }
}



