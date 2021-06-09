//
//  AdminListTableViewCell.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/04/2021.
//

import UIKit

protocol AdminListTableViewCellDelegate: NSObjectProtocol {
    func callBackActionEditAdmin(index: Int)
    func callBackActionDeleteAdmin(index: Int)
    func callBackActionBlockUnBlockAdmin(index: Int)
}

class AdminListTableViewCell: BaseTableViewCell {
    
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var btnBlockWidth: NSLayoutConstraint!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var viewEdit: UIView!
    
    
    //MARK: - OBJECT AND VERIBALES
    weak var delegate: AdminListTableViewCellDelegate?
    var index: Int = -1
    
    //MARK: - OVERRIDE METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    //MARK: - FUNCTIONS
    func configureAdmin(info: AdminViewModel, indexPath: Int){
        self.lblFullName.text = info.firstName + " " + info.lastName
        self.lblEmail.text = info.email
        self.setImageWithUrl(imageView: self.imgImage, url: info.image, placeholder: AssetNames.Box_Blue)
        self.index = indexPath
        
        if info.isBlock == 0{
            self.btnBlock.isSelected = false
        }else{
            self.btnBlock.isSelected = true
        }
        
        if Global.shared.user.loginType == LoginType.super_admin{
            self.btnBlock.isHidden = false
            
        }else{
            self.btnBlock.isHidden = true
        }
        
        
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionEdit(_ sender: UIButton){
        delegate?.callBackActionEditAdmin(index: self.index)
    }
    
    @IBAction func actionDelete(_ sender: UIButton){
        delegate?.callBackActionDeleteAdmin(index: self.index)
    }
    
    @IBAction func actionBlockUnBloack(_ sender: UIButton){
        delegate?.callBackActionBlockUnBlockAdmin(index: self.index)
    }
}
