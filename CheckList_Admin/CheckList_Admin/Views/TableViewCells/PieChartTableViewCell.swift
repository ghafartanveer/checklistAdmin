//
//  PieChartTableViewCell.swift
//  CheckList_Admin
//
//  Created by Rapidzz Macbook on 14/06/2021.
//

import UIKit
import PieCharts

class PieChartTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: SimplePieChartView!
    @IBOutlet weak var viewBackgroung: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.chartView.segments = [
            Segment(color: AppColors.Green,    value: 30),
            Segment(color: AppColors.Pink,   value: 20),
            Segment(color: AppColors.Purple, value: 50)
        ]
        self.viewBackgroung.dropShadow(radius: 5, opacity: 0.5)
        
        
        
        
    }
   func configureView(){
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
