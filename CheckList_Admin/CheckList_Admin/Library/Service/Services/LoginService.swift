
import Foundation
import Alamofire
import SwiftyJSON

class LoginService: BaseService {
    
    //MARK:- Shared Instance
    private override init() {}
    static func shared() -> LoginService {
        return LoginService()
    }
    
    fileprivate func saveUserInfo(_ userInfo:UserViewModel) {
        Global.shared.user = userInfo
        UserDefaultsManager.shared.isUserLoggedIn = true
        UserDefaultsManager.shared.userInfo = userInfo
    }
    
    //MARK: - LOGIN API
    
    func loginApiCall(params:Parameters?,completion: @escaping (_ error: String, _ success: Bool, _ userInfo: UserViewModel?)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.login
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json, responseType) in
            if success{
                let info = UserViewModel(obj: json![KEY_RESPONSE_DATA])
                self.saveUserInfo(info)
                completion(message,success, info)
            }else{
                completion(message,success, nil)
            }
        }
    }
    
    //MARK: - Forget password API
    func forgetPassword(params:Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Forgot_Password
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json, responseType) in
            completion(message,success)
        }
    }
    
    //MARK: - CHNAGE PASSWORD API
    func changePasswordApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        let completeURL = EndPoints.BASE_URL + EndPoints.Change_Password
        self.makePostAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            
            completion(message,success)
        }
    }
    
    //MARK: - UPDATE PASSWORD API
    func updatePasswordApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        let completeURL = EndPoints.BASE_URL + EndPoints.Update_Password
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json, responseType) in
            
            completion(message,success)
        }
    }
    
    //MARK: - LOGOUT API
    func logoutUserApi(params: Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        let completeURL = EndPoints.BASE_URL + EndPoints.Logout_User
        self.makeGetAPICall(with: completeURL, params: params, headers: self.getHeaders()) { (message, success, json, responseType) in
            
            completion(message,success)
        }
    }
    
    //MARK:- PROFILE UPDATE API
    func profileUpdateApi(params: Parameters,dict: [String: Data]?, completion: @escaping (_ error: String, _ success: Bool, _ userInfo: UserViewModel?) ->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Profile_Update
        self.makePostAPICallWithMultipart(with: completeURL, dict: dict, params: params, headers: self.getHeaders()) { (message, success, json, response) in
            
            if success{
                let info = UserViewModel(obj: json![KEY_RESPONSE_DATA])
                self.saveUserInfo(info)
                completion(message, success, info)
            }else{
                completion(message, success, nil)
            }
        }
    }
    
    //MARK: - get token API
    func getToken(params:Parameters?,completion: @escaping (_ message: String, _ success: Bool , _ token : String)->Void){
        let completeURL = EndPoints.BASE_URL
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json, responseType) in
            
            if(success){
                let token = json!["result"]["authorizationToken"].stringValue
                completion(message,success,token)
            }
            else{
                completion(message,success,"")
            }
        }
    }
    
    
}
