//
//  MainContainerViewController.swift
//  SimSwitch
//
//  Created by Gulfam Khan on 30/10/2019.
//  Copyright © 2019 Rapidzz. All rights reserved.
//

import UIKit


import UIKit

class MainContainerViewController: BaseViewController{
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var viewTopColour: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var rightBtn: UIButton!
    
    //MARK: - OBJECT AND VERIABLES
    weak var delegate:TopBarDelegate?
    var baseNavigationController: BaseNavigationController?
    
    //MARK: - OVERRID METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil{
            revealViewController()?.panGestureRecognizer()
            revealViewController()?.tapGestureRecognizer()
            revealViewController()?.rearViewRevealWidth = 320
            revealViewController()?.delegate = self
            self.btnMenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_ :)), for: .touchUpInside)
        }
         //self.showHomeController()
        if(Global.shared.isFromNotification){
           // let notifcationVM = NotificatioViewModel()
            showHistoryController()
            //            if Global.shared.notificationId == 2 {
            //                showCheckListController()
            //            } else {
            //                 // task submitted
            //                showHistoryController()
            //            }
        }
        else{
            self.showHomeController()
        }
    }
        
    //MARK: - IBACTION METHODS
    @IBAction func actionSideMenu(_ sender: UIButton) {
        if revealViewController() != nil{
            revealViewController()?.panGestureRecognizer()
            revealViewController()?.tapGestureRecognizer()
            revealViewController()?.rearViewRevealWidth = 320
            revealViewController()?.delegate = self
            self.btnMenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_ :)), for: .touchUpInside)
        }
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        delegate?.actionBack()
    }
    
    @IBAction func rightBtnAction(_ sender: Any) {
        delegate?.rightButtonAction()
    }
    
    
    //MARK:- FUNCTIONS
    func showCheckListController()  {
        let storyBoard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
        var controller = BaseNavigationController()
        controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.CategoryVC) as! BaseNavigationController
        if let oldRef = self.baseNavigationController {
            oldRef.viewDidDisappear(true)
            oldRef.view.removeFromSuperview()
        }
        self.baseNavigationController = controller
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func showHistoryController()  {
        let storyBoard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
        var controller = BaseNavigationController()
        controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.HistoryNavVC) as! BaseNavigationController
        if let oldRef = self.baseNavigationController {
            oldRef.viewDidDisappear(true)
            oldRef.view.removeFromSuperview()
        }
        self.baseNavigationController = controller
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func isSideMenuSwipeEnabled(isEnable: Bool) {


    }
    func setMenuButton(_ isBack: Bool = false, title: String, isTopBarWhite : Bool? = true)  {
        if(isBack){
            self.imgUser.isHidden = true
            self.btnMenu.removeTarget(nil, action: nil, for: .allEvents)
            self.btnMenu.setImage(UIImage(named: AssetNames.Back_Icon)!, for: .normal)
            self.btnMenu.addTarget(self, action: #selector(MainContainerViewController.actionBack(_:)), for: .touchUpInside)
        }else{
            self.imgUser.isHidden = false
            self.btnMenu.setImage(UIImage(named: AssetNames.sideLogo)!, for: .normal)
            self.btnMenu.addTarget(self, action: #selector(actionSideMenu(_:)), for: .touchUpInside)
        }
        
        
        if isTopBarWhite!{
            self.view.backgroundColor = .white
            self.viewTopColour.backgroundColor = .clear
            self.titleLabel.textColor = .black
            self.btnMenu.tintColor = .black
           // self.viewTopColour.backgroundColor = UIColor.init(hexFromString: "#FF2D55")
            
        }else{
            self.view.backgroundColor = UIColor.init(hexFromString: "#FA5865")
            self.viewTopColour.backgroundColor = UIColor.init(hexFromString: "#FA5865")
            self.titleLabel.textColor = .white
            self.btnMenu.tintColor = .white
        }
        self.titleLabel.text = title
    }
    
    func setRightBtn( isRightHidden: Bool = true, image: UIImage) {
        rightBtn.isHidden = isRightHidden
        rightBtn.setImage(image, for: .normal)
        self.rightBtn.addTarget(self, action: #selector(MainContainerViewController.rightBtnAction(_:)), for: .touchUpInside)
    }
    
    func setTopBarColor(color: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)) {
        self.viewTopColour.backgroundColor = color
    }
    
    func showHomeController()  {
        let storyBoard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
        var controller = BaseNavigationController()
        controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.HomeVC) as! BaseNavigationController
        if let oldRef = self.baseNavigationController {
            oldRef.viewDidDisappear(true)
            oldRef.view.removeFromSuperview()
        }
        self.baseNavigationController = controller
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func showCategoryController()  {
        let storyBoard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
        var controller = BaseNavigationController()
        controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.CategoryVC) as! BaseNavigationController
        if let oldRef = self.baseNavigationController {
            oldRef.viewDidDisappear(true)
            oldRef.view.removeFromSuperview()
        }
        self.baseNavigationController = controller
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    func showAdminController()  {
        let storyBoard = UIStoryboard(name: StoryboardNames.Admin, bundle: nil)
        var controller = BaseNavigationController()
        controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.AdminVC) as! BaseNavigationController
        if let oldRef = self.baseNavigationController {
            oldRef.viewDidDisappear(true)
            oldRef.view.removeFromSuperview()
        }
        self.baseNavigationController = controller
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    func showTechnicianController()  {
        let storyBoard = UIStoryboard(name: StoryboardNames.Admin, bundle: nil)
        var controller = BaseNavigationController()
        controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.TechnicianVC) as! BaseNavigationController
        if let oldRef = self.baseNavigationController {
            oldRef.viewDidDisappear(true)
            oldRef.view.removeFromSuperview()
        }
        self.baseNavigationController = controller
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    func showStoreListController()  {
        let storyBoard = UIStoryboard(name: StoryboardNames.Admin, bundle: nil)
        var controller = BaseNavigationController()
        controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.StoreVC) as! BaseNavigationController
        if let oldRef = self.baseNavigationController {
            oldRef.viewDidDisappear(true)
            oldRef.view.removeFromSuperview()
        }
        self.baseNavigationController = controller
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func showSettingController()  {
        let storyBoard = UIStoryboard(name: StoryboardNames.Registration, bundle: nil)
        var controller = BaseNavigationController()
        controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.SettingVC) as! BaseNavigationController
        if let oldRef = self.baseNavigationController {
            oldRef.viewDidDisappear(true)
            oldRef.view.removeFromSuperview()
        }
        self.baseNavigationController = controller
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    
    func logoutUser()  {
        Global.shared.user = nil
        Global.shared.isLogedIn = false
        UserDefaultsManager.shared.clearUserData()
        UserDefaultsManager.shared.clearToken()
        
        let storyboard = UIStoryboard(name: StoryboardNames.Registration, bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.LoginViewController) as! LoginViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



