//
//  BaseViewController.swift
//  AlKadi
//
//  Created by Khurram Bilal Nawaz on 22/07/2016.
//  Copyright © 2016 Khurram Bilal Nawaz. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
import StoreKit
import AVFoundation
import CropViewController
import CoreLocation


extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}


extension UIViewController{
    
    var mainContainer : MainContainerViewController? {
        
        get{
            var foundController: MainContainerViewController? = nil
            var currentViewController : UIViewController? = self
            
            if(self.isKind(of: MainContainerViewController.self)){
                foundController = (self as! MainContainerViewController)
            }else{
                while true{
                    if let parent = currentViewController?.parent {
                        if parent.isKind(of: MainContainerViewController.self){
                            foundController = (parent as! MainContainerViewController)
                            break
                        }else if parent.isKind(of: BaseNavigationController.self){
                            let navController = parent as! BaseNavigationController
                            if let parentController = navController.view.superview?.parentViewController{
                                if parentController.isKind(of: MainContainerViewController.self){
                                    foundController = (parentController as! MainContainerViewController)
                                    break
                                }
                            }
                        }
                        
                    }
                    else {
                        break
                    }
                    currentViewController = currentViewController?.parent
                }
            }
            
            return foundController
        }
    }
    
}


public class BaseViewController : UIViewController,SWRevealViewControllerDelegate,UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,KYDrawerControllerDelegate, CropViewControllerDelegate {
    
    var hud = MBProgressHUD()
    var disableMenuGesture: Bool = false
    var objAlertVC:BaseViewController?
    var alertView = CustomIOSAlertView()
    var popupAlertView = CustomIOSAlertView()
    
    lazy var profileImagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.tintColor = .white
        view.addTarget(self, action: #selector(handleRefreshController), for: .valueChanged)
        return view
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // self.mainContainer?.setRightButton()
        // self.mainContainer?.topbarView.isHidden = false
    }
    
    @objc func handleRefreshController(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    //    func logoutUserAccount() {
    //        UserDefaultsManager.shared.clearUserData()
    //        let storyboard = UIStoryboard(name: StoryboardNames.Registeration, bundle: nil)
    //       // let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.LoginViewController) as! LoginViewController
    //        if let container = self.navigationController?.navigationController?.parent as? KYDrawerController {
    //       //     container.navigationController?.setViewControllers([controller], animated: true)
    //            container.navigationController?.popToRootViewController(animated: true)
    //        }
    //    }
    
    
    func addTapGesture()  {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    func fetchCameraImage(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            self.profileImagePicker.sourceType = .camera
            self.present(self.profileImagePicker, animated: true, completion:  nil)
        }else{
            print("Camera is not available")
        }
    }
    
    //MARK: location services allowed
    func isLocationOn() -> Bool {
        var isAllow: Bool = false
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                
                case .notDetermined:
                    print("Ask for location access")
                    self.showAlertView(message: PopupMessages.EnableLocationServices, title: ALERT_TITLE_APP_NAME, doneButtonTitle: "Settings", doneButtonCompletion: { (UIAlertAction) in
                        UIApplication.shared.open(URL(string:"App-Prefs:root=PRIVECY")!)
                    }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
                    }
                    //setupLocationManager()
                case .restricted, .denied:
                    print("No access")
                    isAllow = false
                    self.showAlertView(message: PopupMessages.AllowLocationAccesFromSettings, title: ALERT_TITLE_APP_NAME, doneButtonTitle: "Settings", doneButtonCompletion: { (UIAlertAction) in
                        
                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                        
                    }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
                        
                    }
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    //locationManager.startUpdatingLocation()
                    isAllow = true
                @unknown default:
                    break
            }
        } else {
            self.showAlertView(message: PopupMessages.EnableLocationServices, title: ALERT_TITLE_APP_NAME, doneButtonTitle: "Settings", doneButtonCompletion: { (UIAlertAction) in
                UIApplication.shared.open(URL(string:"App-Prefs:root=PRIVECY")!)
            }, cancelButtonTitle: LocalStrings.Cancel) { (UIAlertAction) in
            }
            print("Location services are not enabled")
        }
        return isAllow
    }

    
    func fetchProfileImage(_ message:String = kBlankString){
        let actionSheet = UIAlertController.init(title: "Select Image", message: message, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Camera", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            if(UIImagePickerController.isSourceTypeAvailable(.camera)){
                self.profileImagePicker.sourceType = .camera
                self.present(self.profileImagePicker, animated: true, completion:  nil)
            }else{
                print("Camera is not available")
            }
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Photo Gallary", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.profileImagePicker.sourceType = .photoLibrary
            self.present(self.profileImagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        presentCropViewController(imgToCrop: image)
        
        print("image selected succesfully")
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.profileImagePicker.dismiss(animated: true, completion: nil)
    }
    
    public func presentCropViewController(imgToCrop: UIImage) {
        let image: UIImage = imgToCrop //Load an image
        
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        
        print("Croped image here")
        // 'image' is the newly cropped version of the original image
    }
    
    func showAlertVIew(message:String, title:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            //self.closeAlertMessage()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    public func checkCameraPermission() -> Bool {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized {
            return true
        }else {
            return false
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    func addShadowOnView(view:UIView,color:UIColor,radius:Int,opacity:Float? = 1) {
        //view.center = self.view.center
        view.layer.shadowOpacity = opacity!
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = CGFloat(radius)
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        //self.view.addSubview(view)
    }
    func setBorderColor(view:UIView,color:UIColor? = .white, width:CGFloat? = 1) {
        view.layer.borderWidth = width!
        view.layer.borderColor = color!.cgColor
    }
    
    func stopActivity(containerView: UIView? = nil) {
        MBProgressHUD.hide(for: self.view, animated: true)
        //        if let _ = containerView{
        //            MKProgress.hide()
        //        }else{
        //            MKProgress.hide()
        //        }
    }
    
    func startActivity() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // MKProgress.show()
    }
    
    func checkInternetConnection() -> Bool{
        if(BReachability.isConnectedToNetwork()){
            return true
        }
        self.showAlertVIew(message: PopupMessages.SomethingWentWrong, title: "")
        return false
    }
    
    //Mark:-SetImageWithUrl
    func setImageWithUrl(imageView:UIImageView,url:String, placeholderImage:String? = ""){
        let finalUrl = url.replacingOccurrences(of: " ", with: "%20")
        if let imageurl =  NSURL.init(string: finalUrl){
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_setImage(with: imageurl as URL?, placeholderImage: UIImage(named:placeholderImage!))
        }
    }
    
    func setPlaceholderTextColor(textfield:UITextField,text:String) {
        
        textfield.attributedPlaceholder = NSAttributedString(string: text,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.groupTableViewBackground])
        
        
    }
    func setPlaceholderBlackColor(textfield:UITextField){
        
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder!,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        
    }
    
    
    
    //MARK:-setToolbarOnPickerView
    func addToolBarToPickerView(textField:UITextField)
    {
        var buttonDone = UIBarButtonItem()
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let buttonflexible = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        
        let button =  UIButton(type: .custom)
        button.addTarget(self, action: #selector(BaseViewController.doneClicked(_:)), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.contentMode = UIView.ContentMode.right
        button.frame = CGRect(x:0, y:0, width:60, height:40)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        
        buttonDone = UIBarButtonItem(customView: button)
        
        
        toolbar.setItems(Array.init(arrayLiteral: buttonflexible,buttonDone), animated: true)
        textField.inputAccessoryView = toolbar
        
    }
    
    
    
    
    func addToolBarToPickerViewOnTextview(textview:UITextView)
    {
        var buttonDone = UIBarButtonItem()
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let buttonflexible = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let button =  UIButton(type: .custom)
        button.addTarget(self, action: #selector(BaseViewController.doneClicked(_:)), for: .touchUpInside)
        //button.frame = CGRectMake(0, 0, 53, 31)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        //button.setTitleColor(UIColor(netHex: 0xAE2540), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.contentMode = UIView.ContentMode.right
        button.frame = CGRect(x:0, y:0, width:60, height:40)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        
        buttonDone = UIBarButtonItem(customView: button)
        toolbar.setItems(Array.init(arrayLiteral: buttonflexible,buttonDone), animated: true)
        textview.inputAccessoryView = toolbar
        
    }
    
    override public func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing,animated:animated)
        if (self.isEditing) {
            self.editButtonItem.title = "Editing"
        }
        else {
            self.editButtonItem.title = "Not Editing"
        }
    }
    
    @IBAction func doneClicked(_ sender:AnyObject)
    {
        self.hideKeyboard()
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func showAlertView(message:String) {
        showAlertView(message: message, title: ALERT_TITLE_APP_NAME)
    }
    
    func showAlertView(message:String, title:String, doneButtonTitle:String, doneButtonCompletion: ((UIAlertAction) -> Void)?) {
        showAlertView(message: message, title: title, doneButtonTitle: doneButtonTitle, doneButtonCompletion: doneButtonCompletion, cancelButtonTitle: nil, cancelButtonCompletion: nil)
    }
    
    func showAlertView(message:String, title:String, doneButtonTitle:String = "OK", doneButtonCompletion: ((UIAlertAction) -> Void)? = nil, cancelButtonTitle:String? = nil, cancelButtonCompletion:((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: doneButtonTitle, style: .default, handler: doneButtonCompletion)
        if let cancelTitle = cancelButtonTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelButtonCompletion)
            alertController.addAction(cancelAction)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func buildAlertSheet(with title:String? = nil, message:String? = nil, options:[String], completion: @escaping (Int,String)->Void) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for index in 0..<options.count {
            let action = UIAlertAction(title: options[index], style: .default) { (_) in
                completion(index,options[index])
            }
            
            controller.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: LocalStrings.Cancel, style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func openSettings()  {
        let settingUrl = URL(string: UIApplication.openSettingsURLString)!
        if let _ = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                } else {
                    UIApplication.shared.openURL(settingUrl)
                }
            }
        }
    }
    
    // Resend Message Popup Delegate
    func actionCallBackResend() {
        
    }
    func getUrl(lat: Double, lng : Double) -> String{
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lng)&key=\(kGoogleApiKey)"
        return url
    }
    
    //MARK: - SETUP OBSERVER OF AUTHORIZATION
    func setupAuthObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.userUnAuthorized), name: NotificationName.UnAuthorizedAccess, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationName.UnAuthorizedAccess, object: nil)
    }
    @objc private func userUnAuthorized(){
        GCD.async(.Main) {
            if let topController = UIApplication.shared.topViewController() as? BaseViewController {
                topController.stopActivity()
            }
            
            GCD.async(.Main, delay: 2) {
                UIApplication.shared.endIgnoringInteractionEvents()
                self.showAlertView(message: PopupMessages.Session_Expired, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok) { (_) in
                    self.logoutUserAccount()
                }
            }
        }
    }
}

//MARK: - EXTENSION USER INFO METHODS
extension BaseViewController{
    
    func moveToCreateAdminAndTechnicianVC(isForEdit: Bool, adminObject: AdminViewModel?){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CreateAdminAndTechViewController) as! CreateAdminAndTechViewController
        vc.isForEdit = isForEdit
        vc.adminObjc = adminObject
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToAdminAndTechnicianDetailsVC(adminObject: AdminViewModel?, isFromTechnician: Bool){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.UserDetailsViewController) as! UserDetailsViewController
        vc.isFromTechnician = isFromTechnician
        vc.adminObjc = adminObject
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func saveUserInfo(_ userInfo:UserViewModel) {
        Global.shared.user = userInfo
        Global.shared.isLogedIn = true
        UserDefaultsManager.shared.isUserLoggedIn = true
        UserDefaultsManager.shared.userInfo = userInfo
    }
    
    func loadHomeController(){
        if let container = self.revealViewController()?.frontViewController as? MainContainerViewController{
            container.showHomeController()
        }
    }
    
    func logoutUserAccount() {
        Global.shared.isLogedIn = false
        Global.shared.subCategoryList = [SubCategoryViewModel]()
        Global.shared.subCatIdsToDel = []

        UserDefaultsManager.shared.clearUserData()
        let storyboard = UIStoryboard(name: StoryboardNames.Registration, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.LoginViewController) as! LoginViewController
        if let container = self.navigationController?.parent as? MainContainerViewController {
            container.navigationController?.setViewControllers([controller], animated: true)
            container.navigationController?.popToRootViewController(animated: true)
            
        }else if let container = self.parent as? SWRevealViewController {
            container.navigationController?.setViewControllers([controller], animated: true)
            container.navigationController?.popToRootViewController(animated: true)
        }
    }
}


extension BaseViewController: ChangePasswordPopUpViewControllerDelegate {
    
    func showChangePasswordPopUP(){
        self.alertView = CustomIOSAlertView()
        self.alertView?.buttonTitles = nil
        self.alertView?.useMotionEffects = true
        self.alertView?.touchesEnabled = false
        var demoView:UIView!
        demoView = UIView()
        
        let storyBoard = UIStoryboard(name: StoryboardNames.Registration, bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.ChangePasswordPopUpViewController) as? ChangePasswordPopUpViewController
        {
            
            vc.delegate = self
            
            self.objAlertVC = vc
            demoView.frame = CGRect(x:0, y:0, width: ScreenSize.SCREEN_WIDTH - 30, height: 350)
            vc.view.frame = CGRect(x:0, y:0, width: ScreenSize.SCREEN_WIDTH - 30, height: 350)
            demoView.addSubview(vc.view)
            self.alertView?.containerView = demoView
        }
    }
    
    @objc func callBackActionSubmit(_ currentPassword: String, _ newPassword: String) {
        
    }
    
    @objc func callBackActionClosePopup() {
        
    }
    
    
}

extension BaseViewController: FilterSelctionPopUpViewControllerDelegte {
    
    func showHistorySlectionPopup(){
        self.alertView = CustomIOSAlertView()
        self.alertView?.buttonTitles = nil
        self.alertView?.useMotionEffects = true
        self.alertView?.touchesEnabled = true
        var demoView:UIView!
        demoView = UIView()
        
        let storyBoard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.FilterSelctionPopUpViewController) as? FilterSelctionPopUpViewController
        {
            
            vc.delegate = self
            
            self.objAlertVC = vc
            demoView.frame = CGRect(x:0, y:0, width: ScreenSize.SCREEN_WIDTH - 40, height: 320)
            vc.view.frame = CGRect(x:0, y:0, width: ScreenSize.SCREEN_WIDTH - 40, height: 320)
            
            demoView.addSubview(vc.view)
            
            self.alertView?.containerView = demoView
        }
        
    }
    
    @objc func callBackYesterdayPressed() {
        
    }
    
    @objc func callBackLastWeekPressed() {
        
    }
    
    @objc func callBackLastMonthPressed() {
        
    }
    
    @objc func callBackAllListPressed() {
        
    }
    
    
}
