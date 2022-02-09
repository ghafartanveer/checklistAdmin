
import Foundation
import UIKit


typealias ParamsAny             = [String:Any]
typealias ParamsString          = [String:String]

let ALERT_TITLE_APP_NAME        = "CheckList"
let EMAIL_REGULAR_EXPRESSION    = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
let NAME_REGULER_EXPRESSION = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
struct SideMenu {
    static let SuperAdminMenuList = [["title":"Admin","image":"Admin"],
                           
                           ["title":"Check List","image":"CheckList-menu"],
                           ["title":"Technician","image":"Technician"],
                           ["title":"Store List","image":"StoreList"],
                           ["title":"Setting","image":"settings"]]
    
    static let AdminMenuList = [["title":"Admin","image":"Admin"],
                            ["title":"Check List","image":"CheckList-menu"],
                           ["title":"Technician","image":"Technician"],
                           ["title":"Upgrad Plan ","image":"ic_upgrade"],
                           ["title":"Setting","image":"settings"]]
    
}
struct HomeMenu {
    static let MENU_LIST = [["title":"Admins","image":"Admin-icon", "subTitle": "Number of Admins"],
                            ["title":"Technicians","image":"Technician-icon", "subTitle": "Number of Technicians"],
                            ["title":"All Check List","image":"Group18", "subTitle": "Number of Task's"],
                            ["title":"History","image":"Group22", "subTitle": "All Details"]]
}





struct APIKeys {
    static let googleApiKey     = "AIzaSyBTfypSbx_zNMhWSBXMTA2BJBMQO7_9_T8"
}

struct StoryboardNames {
    static let Registration = "Registration"
    static let Main = "Main"
    static let Home = "Home"
    static let Admin = "Admin"
    static let Category = "Category"
}

struct TitleNames {
    static var Create = "Work List"
    static var Create_Check_List = "Create CheckList"
    static let Home = "Home"
    static let Category_List = "Category List"
    static let Add_Category = "Add Category"
    static let Update_Category = "Update Category"
    static let Admin_List = "Admin List"
    static let Create_Admin = "Create Admin"
    static let Update_Admin = "Update Admin"
    static let Technician = "Technician"
    static let Create_Technician = "Create Technician"
    static let Update_Technician = "Update Technician"
    static let Store_List = "Store List"
    static let Add_Store = "Add Store"
    static let Setting = "Setting"
    static let CheckList = "CheckList"
    static let TechnicianDetails = "Technician Details"
    static let AdminDetails = "Admin Details"
    static let CreateCheckList = "Create checklist"
    static let createTask = "Create Task"
    static let UpdateTask = "Update Task"
    static let History = "History"
    static let HistoryDetails = "History Detail"

    
    
}

struct NotificationName {
    static let UnAuthorizedAccess    = Notification.Name(rawValue: "UnAuthorizedAccess")
}

struct AssetNames {
    static let sideLogo = "menu-icon"
    static let Back_Icon = "back-icon"
    static let Box_Blue = "BoxBlue"
    static let Box_Red = "BoxRed"
    static let Delete_Icon = "deleteIcon"
    static let Edit_Icon = "editIcon"
    static let PdfIcon = "pdf-Icon"
    static let swipeAdit = "edit_icon" // "edit-Swipeicon"
    static let swipeDelete = "DeleteSwipeIcon"
    static let newPdficon = "downloadPdf"//"pdfIcon3"//"pdfIconDowloadCoverted" //"ImagePdf"//"downloadPdf"
}

struct SuperAdminEmail {
    static let super_admin_emailId = "superadminchecklist@yopmail.com"
}

struct LoginType {
    static let Admin = "admin"
    static let super_admin = "super_admin"
    static let Technician = "technician"
}


struct ServiceMessage {
    static let LocationTitle       = "Location Service Off"
    static let LocationMessage     = "Turn on Location in Settings > Privacy to allow myLUMS to determine your Location"
    static let Settings            = "Settings"
    static let CameraTitle         = "Permission Denied"
    static let CameraMessage       = "Turn on Camera in Settings"
}

struct ControllerIdentifier {
    static let CreateCategoryViewController = "CreateCategoryViewController"
    static let SWRevealViewController = "SWRevealViewController"
    static let SubCategoryListViewController = "SubCategoryListViewController"
    static let CreateSubCategoryViewController = "CreateSubCategoryViewController"
    static let HomeVC = "HomeVC"
    static let CategoryVC = "CategoryVC"
    static let AdminVC = "AdminVC"
    static let TechnicianVC = "TechnicianVC"
    static let StoreVC = "StoreVC"
    static let SettingVC = "SettingVC"
    static let SWRevealVC = "SWRevealVC"
    static let CategoryListViewController = "CategoryListViewController"
    static let AdminListViewController = "AdminListViewController"
    static let ChangePasswordPopUpViewController = "ChangePasswordPopUpViewController"
    static let CreateAdminAndTechViewController = "CreateAdminAndTechViewController"
    static let LoginViewController = "LoginViewController"
    static let AddCategoryViewController = "AddCategoryViewController"
    static let AddStoreViewController = "AddStoreViewController"
    static let ForgotPasswordViewController = "ForgotPasswordViewController"
    static let UpdatePasswordViewController = "UpdatePasswordViewController"
    static let TechnicianListViewController = "TechnicianListViewController"
    static let UserDetailsViewController = "UserDetailsViewController"
    static let CreateNewTaskViewController = "CreateNewTaskViewController"
    static let FilterSelctionPopUpViewController = "FilterSelctionPopUpViewController"
    static let HistoryDetailsViewController = "HistoryDetailsViewController"
    static let CheckListHistoryViewController = "CheckListHistoryViewController"
    static let HistoryPdfGeneratorViewController = "HistoryPdfGeneratorViewController"
    static let HistoryNavVC = "HistoryNavVC"
    static let AdminSignupViewController = "AdminSignupViewController"
    static let StoreWorkerListViewController = "StoreWorkerListViewController"
    static let WebViewNavVC = "WebViewNavVC"
}

struct ValidationMessages {
    static let VerifyNumber = "Please Verify Your Number"
    static let EmptyPhonNumber = "Please enter phone number"
    static let SomeThingWrong = "SomeThingWrong"
    static let PhoneNumberVerified = "PhoneNumber Verified Successfully"
    static let WrondPinCode = "Please Enter A Valid VerificationCode"
    static let loginSuccessfully = "You are logged in"
    static let selectProfileimage = "Select Profile Image"
    static let Empty_First_Name = "Please enter your first name"
    static let Empty_Last_Name = "Please enter your last name"
    static let Empty_Store_Name = "Please enter store name"
    static let Empty_Store_Address = "Please enter store address"
    static let Empty_City_Name = "Please enter your city name"
    static let Empty_State_Name = "Please enter your state name"
    static let Empty_ZipCode_Name = "Please enter your zip code"
    static let Valid_City_Name = "Please enter a valid city name"

    static let Empty_Full_Name = "Please enter your name"
    static let emptyEmail                   = "Please enter your email"
    static let enterValidEmail              = "Please enter valid email"
    static let emptyPassword                = "Password field cannot be empty"
    static let shortPassword                = "Password must be atleast 6 characters"
    static let reTypePassword               = "Please re-type password"
    static let nonMatchingPassword          = "Password is not matching"
    static let invalidPhoneNumber           = "Enter a valid phone number"
    static let configurationUrl             = "Please enter configuration url"
    static let validUrl                     = "Please enter valid url"
    static let emptyPhonNumber              = "Please enter phone number"
    static let emptyPincode                 = "Please enter pincode from email to continue"
    static let emptyCategoryName            = "Please enter category name first"
    static let emptyProductName             = "Please enter product name first"
    static let invalidProductPrice          = "Please enter a valid price for product"
    static let emptyProductInfo             = "Please describe product briefly"
    static let noImageProduct               = "Add at least one image of product"
    static let selectWeightUnit             = "Select product weight unit first"
    static let commentsMissing              = "Comment field cannot empty"
    static let noLocationAdded              = "Location info is must in order to become a supplier"
    static let fillAllFields              = "Please fill all fields"
    static let taskName = "Please enter task name"
    static let enterAValidPhone = "Please enter a valid phone number"
    static let tasknameAlreadyExist = "Task Already Exists!"
}
struct CellIdentifier {
    static let TaskCategoryTableViewCell = "TaskCategoryTableViewCell"
    static let TaskTypesTableViewCell = "TaskTypesTableViewCell"
    static let HomeCollectionViewCell = "HomeCollectionViewCell"
    static let SubCategoryListTableViewCell = "SubCategoryListTableViewCell"
    static let CategoryListTableViewCell = "CategoryListTableViewCell"
    static let SideMenuTableViewCell = "SideMenuTableViewCell"
    static let AdminListTableViewCell = "AdminListTableViewCell"
    static let CalenderTableViewCell = "CalenderTableViewCell"
    static let TechnicianListTableViewCell = "TechnicianListTableViewCell"
    static let StoreListTableViewCell = "StoreListTableViewCell"
    static let CategoryDropDownTableViewCell = "CategoryDropDownTableViewCell"
    static let CreateSubCategoryTableViewCell = "CreateSubCategoryTableViewCell"
    static let PieChartTableViewCell = "PieChartTableViewCell"
    static let BarChartCollectionViewCell = "BarChartCollectionViewCell"
    static let BarChartTableViewCell = "BarChartTableViewCell"
    static let TechnicianDetailTableViewCell = "TechnicianDetailTableViewCell"
    static let HistoryDetailsTaskListTableViewCell = "HistoryDetailsTaskListTableViewCell"
    static let TaskHistoryTableViewCell = "TaskHistoryTableViewCell"
    
}


struct PopupMessages {
    static let emptySearch = "Please enter something for search"
    static let verification = "Verification Code Sent Again Successfully"
    static let Sure_To_Delete_Store = "Are you sure you want to delete this Store?"
    static let Sure_To_Delete_Technician = "Are you sure to delete Technician"
    static let Sure_To_Delete_Admin = "Are you sure to delete Admin"
    static let Sure_To_Delete_Category = "Are you sure to delete Category"
    static let LocationNotFound             = "Location Not found"
    static let cantSendMessage              = "Cant Send Message Now Please Try Agian Later"
    static let warning                      = "Warning"
    static let sureToLogout                 = "Are you sure you want to logout?"
    static let nothingToUpdate              = "Nothing to update"
    static let orderMarkedCompleted         = "Order marked completed successfullly"
    static let Session_Expired    = "Session expired, please login again"
    static let cameraPermissionNeeded       = "Camera permission needed to scan QR Code. Goto settings to enable camera permission"
    static let SomethingWentWrong           = "Something went wrong, please check your internet connection or try again later!"
    static let ChecklistCreated = "Checklist added succesfully"
    static let TechAddedSuccess = "Technician added successfully!"
    static let AdminAddedSuccess = "Admin added successfully!"
    
    static let ChecklistUpdated = "Checklist updated succesfully"
    static let TechUpdatedSuccess = "Technician updated successfully!"
    static let AdminUpdatedSuccess = "Admin updated successfully!"
    static let Sure_To_Delete_Task = "Are you sure to delete Task"
    static let Sure_To_Delete_Check_List = "Are you sure you want to delete this Check List?"
    static let youDontHavePermitonForTheFeature = "You do not have permission to access this feature!"
    static let sureToGoBackWithOutSaving = "New added tasks will be lost if you go back. Are you sure you want to go back?"
    static let TaskAddedSuccessfully = "Task added Successfully!"
    static let TaskUpdatedSuccessfully = "Task updated Successfully!"
    static let EntertaskName = "Plese Enter task Title!"
    static let PleaseAddAtLeastOneTask = "Please add at least one task!"
    static let pdfCreatedSuccess = "Pdf report saved successfully!"
    static let PleaseLogInAsAdmin = "Please login as admin"
    
}

struct LocalStrings {
    static let Warning = "Warning!"
    static let success              = "Success"
    static let ok                   = "OK"
    static let Yes                  = "Yes"
    static let No                   = "No"
    static let edit                 = "Edit"
    static let delete               = "Delete"
    static let Cancel               = "Cancel"
    static let Camera               = "Camera"
    static let complete             = "COMPLETE"
    static let prepare              = "PREPARE"
    static let update               = "UPDATE"
    static let NoDataFound          = "No data found"
    static let EnterUsername        = "Enter Username"
    static let EnterEmail           = "Enter Email"
    static let OldPassword          = "Old Password"
    static let EnterOldPassword     = "Enter old password"
    static let ChangePassword       = "CHANGE PASSWORD"
    static let noDescription        = "No description available"
    static let cancellationReason   = "Cancellation Reason"
    static let deleteProduct        = "Please Select Product To Delete"
    static let enableProduct        = "Please Select Product To Enable"
    static let disableProduct       = "Please Select Product To Disable"
    static let EmptySubject        = "Please Enter Subject"
    static let EmptyMessage        = "Please Enter Message"
    static let Save = "Save"
}


struct AppFonts {
    static func CenturyGolthicBoldWith(size : CGFloat) -> UIFont {
        
        if let font = UIFont(name: "Century Gothic Bold", size: size) {
            return font
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    static func CenturyGolthicRegularWith(size : CGFloat) -> UIFont {
        
        if let font = UIFont(name: "Century Gothic Regular", size: size) {
            return font
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}
