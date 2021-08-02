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
    
    func getParams(ids:[Int] = []) -> ParamsAny {
        var categoryParam = [ParamsAny]()
        var imageStrArray:[String] = [""]
        let idArr:[Int] = ids
        for question in subCategoryList {
            let questionParams : ParamsAny = ["id" : question.id,"sub_category_name" : question.subcategoryName,"not_applicable": question.notApplicable,"sub_category_description" :question.subcategoryDescription, "is_priority" : question.isPriority ]
            
            categoryParam.append(questionParams)
        }
//        for idOfSubCat in subCategoryList {
//            idArr.append(idOfSubCat.id)
//        }
        for imgDesc in 0..<imagesList.count {
            let desc = self.imagesList[imgDesc].image.description
            if !desc.isEmpty {
            imageStrArray.append(desc)
            }
        }
        
        let param: ParamsAny = [  "checkListQuestions" : categoryParam ,"hasImages" : self.hasImages, "id" : self.id, "imagesRequired": imageStrArray, "sub_cat_ids": idArr]
        return param
    }
}

//{
//    "checkListQuestions": [
//    {
//    "id": "",
//    "is_priority": 1,
//    "not_applicable": "1",
//    "sub_category_description": "",
//    "sub_category_name": "Testing task 4324"
//    }
//    ],
//    "hasImages": 0,
//    "id": 1,
//    "imagesRequired": [
//    ""
//    ],
//    "sub_cat_ids": []
//}
