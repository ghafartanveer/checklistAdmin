//
//  CategoryService.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 06/05/2021.
//

import Foundation
import SwiftyJSON
import Alamofire


class StoreCategoryService: BaseService{
    
    //MARK:- Shared Instance
    private override init() {}
    static func shared() -> StoreCategoryService {
        return StoreCategoryService()
    }
    
    
    //MARK:- CATEGORY LIST API
    func categoryListApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool, _ admin: CategoryListViewModel?)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.categories_List
        self.makeGetAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                let info = CategoryListViewModel(list: json![KEY_RESPONSE_DATA])
                completion(message,success, info)
            }else{
                completion(message,success, nil)
            }
           
        }
    }
    
    //MARK:- ADD CATEGORY API
    func addCategoryApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Add_Checklist_Category
        self.makePostAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            
                completion(message,success)
        }
    }
    //MARK:- DELETE CATEGORY API
    func deleteCategoryApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Delete_Category
        self.makePostAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            
                completion(message,success)
        }
    }
    //MARK:- UPDATE CATEGORY API
    func updateCategoryApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Update_Category
        self.makePostAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            
                completion(message,success)
        }
    }
    
    
    //MARK: - STORE LIST API
    func storeListApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool, _ admin: StoreListViewModel?)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.stores_List
        self.makeGetAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            
            
            if success{
                let info = StoreListViewModel(list: json![KEY_RESPONSE_DATA])
                completion(message,success, info)
            }else{
                completion(message,success, nil)
            }
           
        }
    }
    //MARK: - ADD STORE API
    func addStoreApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Add_Store
        self.makePostAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            
            completion(message,success)
            
        }
    }
    
    //MARK: - UPDATE STORE API
    func updateStoreApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Update_Store
        self.makePostAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            
            completion(message,success)
            
        }
    }
    //MARK: - UPDATE STORE API
    func deleteStoreApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Delete_Store
        self.makePostAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            
            completion(message,success)
            
        }
    }
    
    
}
