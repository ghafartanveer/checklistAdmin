//
//  SubCategoryListTableViewCell.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 28/05/2021.
//

import UIKit

protocol SubCategoryListTableViewCellDelegate: NSObjectProtocol {
    func callBackActionMarkPriority(index: Int)
    func callBackActionNotAvailable(index: Int)
}
class SubCategoryListTableViewCell: UITableViewCell {
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var btnPriority: UIButton!
    @IBOutlet weak var btnNotAvailable: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var dscriptionLbl: UILabel!
    
    @IBOutlet weak var descriptionLblContainer: UIView!
    
    //MARK: - OBJECT AND VERIBALES
    weak var delegate: SubCategoryListTableViewCellDelegate?
    var index: Int = -1
    
    
    //MARK: - OVERRIDE METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - FUNCTIONS
    
    
//    func configureSubCategory(info: CheckListQuestionViewModel){
//        self.lblTitle.text = info.sub_category_name
//
//        if info.sub_category_description.isEmpty || info.sub_category_description == "null" {
//            dscriptionLbl.text = ""
//        } else {
//            dscriptionLbl.text = info.sub_category_description
//        }
//        if info.is_priority == 1{
//            self.btnPriority.isSelected = true
//        }
//        if info.not_applicable == 1{
//            self.btnNotAvailable.isSelected = true
//        }
//    }
    
    func configureSubCategory(info: SubCategoryViewModel){
        self.lblTitle.text = info.subcategoryName
        print("Desc : ", info.subcategoryDescription)
        print("Note : ", info.note)
        if info.subcategoryDescription.isEmpty || info.subcategoryDescription == "null" {
            dscriptionLbl.text = ""
        } else {
            dscriptionLbl.text = info.subcategoryDescription
        }
        
        if info.note.isEmpty || info.note == "null" {
            dscriptionLbl.text = ""
        } else {
            dscriptionLbl.text = info.subcategoryDescription
        }
        
        if info.isPriority == 1 {
            self.btnPriority.isSelected = true
        } else {
            self.btnPriority.isSelected = false
        }
        if info.notApplicable == 1 {
            self.btnNotAvailable.isSelected = true
        } else {
            self.btnNotAvailable.isSelected = false
        }
    }
    
    
    //MARK: - IBACTION METHODS
    @IBAction func actionPriority(_ sender: UIButton){
        if self.btnPriority.isSelected{
            self.btnPriority.isSelected = false
        }else{
            self.btnPriority.isSelected = true
        }
       // delegate?.callBackActionMarkPriority(index: self.index)
    }
    
    @IBAction func actionNotAvailable(_ sender: UIButton){
        if self.btnNotAvailable.isSelected{
            self.btnNotAvailable.isSelected = false
        }else{
            self.btnNotAvailable.isSelected = true
        }
        //delegate?.callBackActionNotAvailable(index: self.index)
    }
}
