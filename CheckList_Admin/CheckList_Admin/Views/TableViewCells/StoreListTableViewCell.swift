//
//  StoreListTableViewCell.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 06/05/2021.
//

import UIKit

protocol StoreListTableViewCellDelegate: NSObjectProtocol {
    func callBackActionEditStore(index: Int)
    func callBackActionDeleteStore(index: Int)
}

class StoreListTableViewCell: BaseTableViewCell {
    //MARK: - IBOUTLETS
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblAddres: UILabel!
   
    
    //MARK: - OBJECT AND VERIBALES
    weak var delegate: StoreListTableViewCellDelegate?
    var index: Int = -1
    
    //MARK: - OVERRIDE METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //MARK: - FUNCTIONS
    func configureStore(info: StoreViewModel, indexP: Int){
        self.lblStoreName.text = info.name
        self.lblAddres.text = info.address + " " + info.city
        self.index = indexP
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func actionEdit(_ sender: UIButton){
        delegate?.callBackActionEditStore(index: self.index)
    }
    
    @IBAction func actionDelete(_ sender: UIButton){
        delegate?.callBackActionDeleteStore(index: self.index)
    }
}
