//
//  CreateSubCategoryTableViewCell.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/05/2021.
//

import UIKit

class CreateSubCategoryTableViewCell: BaseTableViewCell {
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var btnPriority: UIButton!
    @IBOutlet weak var btnNotAvailable: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: - OBJECT AND VERIBALES
    weak var delegate: SubCategoryListTableViewCellDelegate?
    var index: Int = -1
    
    
    //MARK: - OVERRIDE METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - FUNCTIONS
    func configureSubCategory(info: SubCategoryViewModel){
        self.lblTitle.text = info.subcategoryName
        
        if info.isPriority == 1{
            self.btnPriority.isSelected = true
        }
        if info.notApplicable == 1{
            self.btnNotAvailable.isSelected = true
        }
    }
    
    
  
}
