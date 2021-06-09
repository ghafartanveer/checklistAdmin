//
//  CreateSubCategoryViewController.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/05/2021.
//

import UIKit

class CreateSubCategoryViewController: BaseViewController {
    
    @IBOutlet weak var btnPriority: UIButton!
    @IBOutlet weak var btnNotAvailable: UIButton!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var viewImageDespHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionPriority(_ sender: UIButton){
        if self.btnPriority.isSelected{
            self.btnPriority.isSelected = false
        }else{
            self.btnPriority.isSelected = true
        }
    }
    
    @IBAction func actionNotAvailable(_ sender: UIButton){
        if self.btnNotAvailable.isSelected{
            self.btnNotAvailable.isSelected = false
        }else{
            self.btnNotAvailable.isSelected = true
        }
    }
   
}
