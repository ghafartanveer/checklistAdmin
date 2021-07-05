//
//  AddSubCatViewModel.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 02/07/2021.
//

import Foundation

class CategoryTaskViewModel {
    var id: Int
    var name: String
    var hasImages : String
    var checkListQuestions: [CheckListQuestionViewModel]
    var imagesRequired : [String]
    
    init() {
        self.id = 0
        self.name = ""
        self.hasImages = ""
        self.checkListQuestions = []
        self.imagesRequired = []
    }
    
//    func getParams() -> ParamsAny {
//        var categoryParam = [ParamsAny]()
//        
//        for question in checkListQuestions {
//            let questionParams : ParamsAny = ["id" : question.id,"sub_category_name" : question.sub_category_name,"not_applicable": question.not_applicable,"sub_category_description" :question.sub_category_description, "is_priority" : question.is_priority ]
//            
//            categoryParam.append(questionParams)
//        }
//        let param: ParamsAny = ["id" : id, "name" : name, "hasImages" : hasImages ,  "checkListQuestions" : categoryParam , "imagesRequired": imagesRequired]
//        return param
//    }
}

struct CheckListQuestionViewModel {
    var id : Int
    var sub_category_name : String
    var not_applicable : Int
    var sub_category_description : String
    var is_priority : Int
}


//
//{
//    "id": 1,
//    "name": "Radio install",
//    "hasImages" : "true",
//    "checkListQuestions": [
//    {
//    "id": "3",
//    "sub_category_name": "this is test question 3",
//    "not_applicable" : "1",
//    "sub_category_description" : "1",
//    "is_priority" : 1,
//    }
//    ],
//    "imagesRequired" :["Front Side of Car", "back side of car" ]
//}
