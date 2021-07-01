//
//  TechnicianDetailTableViewCell.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 01/07/2021.
//

import UIKit

class TechnicianDetailTableViewCell: BaseTableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fulNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureTechnician(info: AdminViewModel, indexP: Int){
    
        self.fulNameLbl.text = info.firstName + " " + info.lastName
        self.emailLbl.text = info.email
        self.setImageWithUrl(imageView: self.userImageView, url: info.image, placeholder: AssetNames.Box_Blue)

    }
    func configureCellDetails(info: AdminViewModel) {
        shadowView.dropShadow()
         self.setImageWithUrl(imageView: userImageView, url: info.image)
        userImageView.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
        
        emailLbl.text = info.email
        fulNameLbl.text = info.firstName + " " + info.lastName
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
