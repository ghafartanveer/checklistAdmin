//
//  TaskTypesTableViewCell.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 27/04/2021.
//

import UIKit

class TaskTypesTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func ConfigureTypes(index: Int){
        if index == 0{
            self.lblTitle.text = "Pie chart"
            self.imgImage.image = UIImage(named: AssetNames.Box_Red)
        }else{
            self.lblTitle.text = "Graphs/Statistics"
            self.imgImage.image = UIImage(named: AssetNames.Box_Blue)
        }
        self.viewShadow.dropShadow(radius: 5, opacity: 0.4)
    }
    

}
