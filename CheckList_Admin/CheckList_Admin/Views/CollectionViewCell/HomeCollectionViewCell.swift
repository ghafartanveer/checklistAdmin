//
//  HomeCollectionViewCell.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 27/04/2021.
//

import UIKit

class HomeCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imgBox: UIImageView!
    @IBOutlet weak var lblCount: UILabel!
    
    func configureMenu(data: [String: String], index: Int,countTxt: Int){
        
        if (Global.shared.user.loginType == LoginType.Admin) && index == 0{
            viewShadow.alpha = 0.7
            viewShadow.backgroundColor = .lightGray
            lblCount.isHidden = true
        } else {
            viewShadow.alpha = 1.0
            viewShadow.backgroundColor = .white
            lblCount.isHidden = false
            
        }
        
        lblCount.text = String(countTxt)
        self.lblTitle.text = data["title"] ?? ""
        self.lblSubTitle.text = data["subTitle"] ?? ""
        self.imgImage.image = UIImage(named: data["image"]!)
        self.viewShadow.dropShadow(radius: 5, opacity: 0.5)
        self.imgBox.image = self.imgBox.image?.withRenderingMode(.alwaysTemplate)
        if(index == 0){
            self.imgBox.tintColor = UIColor.systemBlue
        }else if(index == 1){
            self.imgBox.tintColor = UIColor.systemPink
        }else if(index == 2){
            self.imgBox.tintColor = UIColor.systemGreen
        }else if(index == 3){
            self.imgBox.tintColor = UIColor.systemPurple
        }
        
    }
}
