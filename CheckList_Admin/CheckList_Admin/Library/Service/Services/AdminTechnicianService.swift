//
//  AdminService.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 05/05/2021.
//

import Foundation
import SwiftyJSON
import Alamofire


class AdminTechnicianService: BaseService{
    
    //MARK:- Shared Instance
    private override init() {}
    static func shared() -> AdminTechnicianService {
        return AdminTechnicianService()
    }
    
    
    //MARK:- ADMIN LIST API
    func adminListApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool, _ admin: AdminListViewModel?)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.admins_List
        self.makeGetAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            if success{
                let info = AdminListViewModel(list: json![KEY_RESPONSE_DATA])
                completion(message,success, info)
            }else{
                completion(message,success, nil)
            }
        }
    }
    
    //MARK:- DELETE ADMIN AND TECHNICIAN API
    func deleteAdminOrTechnicianApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool, _ admin: AdminListViewModel?)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Delete_User
        self.makePostAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
           
                completion(message,success, nil)
        }
    }
    
    //MARK:- BLOCK TECHNICIAN API
    func blockAdminOrTechnicianApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool, _ admin: AdminListViewModel?)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Block_User
        self.makePostAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
           
                completion(message,success, nil)
        }
    }
    
    //MARK:- ADD ADMIN API
    func registerAdminAndTechnicianApi(params: Parameters,dict: [String: Data]?, completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Register
        self.makePostAPICallWithMultipart(with: completeURL, dict: dict, params: params, headers: self.getHeaders()) { (message, success, json, response) in
            
            completion(message, success)
        }
    }
    //MARK:- UPDATE ADMIN AND TECHNICIAN API
    func updateAdminAndTechnicianApi(params: Parameters,dict: [String: Data]?, completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Profile_Update
        self.makePostAPICallWithMultipart(with: completeURL, dict: dict, params: params, headers: self.getHeaders()) { (message, success, json, response) in
            
            completion(message, success)
        }
    }
    
    //MARK: - TECHNICIAN LIST API
    func technicianListApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool, _ admin: AdminListViewModel?)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.technicians_List
        self.makeGetAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            
            
            if success{
                let info = AdminListViewModel(list: json![KEY_RESPONSE_DATA])
                completion(message,success, info)
            }else{
                completion(message,success, nil)
            }
           
        }
    }
    
   
}
