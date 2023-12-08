import Foundation
import UIKit
struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X_All = (UIDevice.current.userInterfaceIdiom == .phone && (ScreenSize.SCREEN_MAX_LENGTH == 812 || ScreenSize.SCREEN_MAX_LENGTH == 896))
    static let IS_IPHONE_X = (UIDevice.current.userInterfaceIdiom == .phone && (ScreenSize.SCREEN_MAX_LENGTH == 812))
    static let IS_IPHONE_X_MAX = (UIDevice.current.userInterfaceIdiom == .phone && (ScreenSize.SCREEN_MAX_LENGTH == 896))
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
}

struct AppColors {
    static let yellow           = UIColor(rgbValues: 249, green: 177, blue: 31, alpha: 1)
    static let LightGray        = UIColor.init(hexFromString: "0x969696", alpha: 0.61)
    static let LightBlue        = UIColor.init(hexFromString: "0x093485", alpha: 0.61)
    static let Gray             = UIColor.init(hexFromString: "0x969696")
    static let DarkBlue         = UIColor.init(hexFromString: "0x093485")
    static let Green         = UIColor.init(hexFromString: "0x185D62")
    static let Purple         = UIColor.systemPurple
    static let Pink         = UIColor.systemPink
}


struct DictKeys {
    static let formatted_address = "formatted_address"
    static let hasImages = "has_images"
    static let email = "email"
    static let name = "name"
    static let results = "results"
    static let address = "address"
    static let city = "city"
    static let state = "state"
    static let zip_code = "zip_code"
    static let password = "password"
    static let login_type = "login_type"
    static let authoraization = "authoraization"
    static let Store_Id = "store_id"
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let store_name = "store_name"
    static let store_address = "store_address"
    static let image = "image"
    static let phone_number = "phone_number"
    static let User_Id = "user_id"
    static let Category_Id = "category_id"
    static let Current_Password = "current_password"
    static let New_Password = "new_password"
    static let Pin_Code = "pin_code"
    static let fcm_token = "fcm_token"
    static let sub_category_name = "sub_category_name"
    static let not_applicable = "not_applicable"
    static let is_priority = "is_priority"
    static let is_payable = "is_payable"
    static let is_admin = "is_admin"
    
}

struct EndPoints {
    static let PAYMENT_URL = "http://12voltqc.com/pricing_plans/"//"http://mashghol.com/checklist_app/public/pricing_plans/"
    static let BASE_URL = "http://12voltqc.com/api/"//"http://mashghol.com/checklist_app/public/api/"
    static let login = "login"
    static let admins_List = "admins_list"
    static let categories_List = "categories_list"
    static let technicians_List = "technicians_list"
    static let stores_List = "stores_list"
    static let Add_Store = "add_store"
    static let Update_Store = "update_store"
    static let Delete_Store = "delete_store"
    static let Register = "register"
    static let Profile_Update = "profile_update"
    static let Delete_User = "delete_user"
    static let Add_Checklist_Category = "add_checklist_category"
    static let Delete_Category = "delete_category"
    static let Update_Category = "update_category"
    static let Change_Password = "change_password"
    static let Forgot_Password = "forgot_password"
    static let Update_Password = "update_password"
    static let Logout_User = "logout_user"
    static let Block_User = "block_user"
    static let Create_Task = "create_task"
    static let Create_Cubcategories = "create_subcategories"
    static let History = "history"
    static let Search = "search"
    static let GraphStats = "stats"
    static let States = "statistics"
    static let admin_approval = "admin_approval"
    

}

//Default values for data types
let kBlankString = ""
let Plateform = "IOS"
let DeviceToken = "21321312"

let kInt0 = 0
let kIntDefault = -1

let kDouble0 = 0.0
let kDoubleDefault = -1.0

let kFileTypePDF = "pdf"
let kFileTypeJpeg = "jpeg"

let kMimeTypeImage = "image/png"
let kImageFileName = "file.png"

let kMimeTypePDF = "application/pdf"
let kPDFFileName = "document.pdf"

let kGoogleApiKey = "AIzaSyBSkxWfplDOp616q8aVOTWWacn0P8erFVI"



