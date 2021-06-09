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
    
    func configureMenu(data: [String: String]){
        self.lblTitle.text = data["title"]
        self.lblSubTitle.text = data["subTitle"]
        self.imgImage.image = UIImage(named: data["image"]!)
        self.viewShadow.dropShadow(radius: 5, opacity: 0.5)
        
    }
}
