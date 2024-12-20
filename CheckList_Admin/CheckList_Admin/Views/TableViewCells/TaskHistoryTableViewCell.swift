//
//  TaskHistoryTableViewCell.swift
//  Checklist
//
//  Created by Muaaz Ahmad on 18/06/2021.
//

import UIKit

protocol TaskHistoryTableViewCellDelegate: NSObjectProtocol {
    func seeDetilsCallBack(index:Int)
    func selectCellHistory(index: Int, cell: TaskHistoryTableViewCell)
}

class TaskHistoryTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var customeNameLbl: UILabel!
    @IBOutlet weak var regNoLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var checkBtn: UIButton!
    weak var delegate: TaskHistoryTableViewCellDelegate?
    var cellIndex = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBtn.isHidden = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureHistoryList(info: HistoryTaskViewModel) {
        
//        if pdfRecordsList.contains(where: info) {
//            
//        }
        self.customeNameLbl.text = (info.technician?.firstName ?? "") + " " + (info.technician?.lastName ?? "") 
        
        self.regNoLbl.text = info.technician?.email ?? ""
        let checkInDateTime = info.createdAt
        self.dateLbl.text = Utilities.getDatefromDateString(strDate: checkInDateTime ?? "", formate: "yyyy-MM-dd")
                                                            
        self.timeLbl.text = Utilities.getTimeFromDateString(strDate: checkInDateTime ?? "")
        
        self.checkBtn.isSelected = info.isSelectedForPdf
    }
    
    @IBAction func seeDetails(_ sender: Any) {
        delegate?.seeDetilsCallBack(index: cellIndex)
    }
    
    
    @IBAction func checkboxAction(_ sender: Any) {
        delegate?.selectCellHistory(index:cellIndex, cell: self)
    }
    
}
