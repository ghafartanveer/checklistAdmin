//
//  AdminViewModel.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 05/05/2021.
//

import Foundation
import SwiftyJSON

class AdminViewModel {
    
    var id: Int
    var storeID: Int
    var isBlock: Int
    var firstName: String
    var lastName: String
    var email : String
    var phoneNumber: String
    var image: String
    var gender: String
    var fcmToken: String
    var loginType: String
    var createdAt: String
    
    
    
     init(){
        self.id = 0
        self.storeID = 0
        self.isBlock = 0
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.phoneNumber = ""
        self.image = ""
        self.loginType = ""
        self.gender = ""
        self.fcmToken = ""
        self.createdAt = ""
    }
    
    convenience init(obj: JSON){
        self.init()
        self.id = obj["id"].int ?? 0
        self.storeID = obj["store_id"].int ?? 0
        self.isBlock = obj["is_block"].int ?? 0
        self.firstName = obj["first_name"].string ?? ""
        self.lastName = obj["last_name"].string ?? ""
        self.email = obj["email"].string ?? ""
        self.phoneNumber = obj["phone_number"].string ?? ""
        self.image = obj["image"].string ?? ""
        self.loginType = obj["login_type"].string ?? ""
        self.gender = obj["gender"].string ?? ""
        self.fcmToken = obj["fcm_token"].string ?? ""
        self.createdAt = obj["created_at"].string ?? ""
    }
    
}
