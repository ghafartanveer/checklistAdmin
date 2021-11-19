//
//  CheckListService.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 02/07/2021.
//

import Foundation
import Alamofire

class CheckListService: BaseService {
    //MARK:- Shared Instance
    private override init() {}
    static func shared() -> CheckListService {
        return CheckListService()
    }
    
    
    //MARK:- CREATE TASK API
    func CreateNewTaskApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool, _ info: SubCategoryViewModel?)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Create_Task
        self.makePostAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                let info = SubCategoryViewModel(obj: json![KEY_RESPONSE_DATA])
                completion(message,success, info)
            }else{
                completion(message,success, nil)
            }
            
        }
    }
    
    
    
}
