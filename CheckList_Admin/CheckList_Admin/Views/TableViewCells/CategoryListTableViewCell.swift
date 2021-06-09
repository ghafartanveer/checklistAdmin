//
//  CategoryListTableViewCell.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/04/2021.
//

import UIKit

protocol CategoryListTableViewCellDelegate: NSObjectProtocol {
    func callBackActionDeleteCategory(index: Int)
    func callBackActionEditCategory(index: Int)
}

class CategoryListTableViewCell: BaseTableViewCell {
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    //MARK: - OBJECT AND VERIABLES
    weak var delegate: CategoryListTableViewCellDelegate?
    var index: Int = -1
    
    
    //MARK: - OVERRIDE METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - FUNCTIONS
    func configureCategory(info: CategoryViewModel, index: Int){
        self.lblName.text = info.name
        self.index = index
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionEdit(_ sender: UIButton){
        delegate?.callBackActionEditCategory(index: self.index)
    }
    
    @IBAction func actionDelete(_ sender: UIButton){
        delegate?.callBackActionDeleteCategory(index: self.index)
    }
}
