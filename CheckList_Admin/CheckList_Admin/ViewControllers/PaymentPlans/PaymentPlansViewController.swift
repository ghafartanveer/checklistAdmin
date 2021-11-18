//
//  PaymentPlansViewController.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmed on 17/11/2021.
//

import UIKit
import WebKit

class PaymentPlansViewController: BaseViewController, UITabBarDelegate, TopBarDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
            //let webView = WKWebView()
            //self.view.addSubview(webView)
        let userId = Global.shared.user.id
        let completeUrl = EndPoints.PAYMENT_URL + "\(userId)"
            let url = URL(string: completeUrl)
            webView.load(URLRequest(url: url!))
    }

    override func viewWillAppear(_ animated: Bool) {
        if let container = self.mainContainer{
            container.delegate = self
            container.setMenuButton(true, title: "Check-List", isTopBarWhite: false)
        }
    }
    
    func actionBack() {
        self.loadHomeController()

    }
    
}
