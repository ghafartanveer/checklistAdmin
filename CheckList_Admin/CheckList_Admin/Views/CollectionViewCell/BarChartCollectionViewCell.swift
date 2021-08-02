//
//  BarChartCollectionViewCell.swift
//  GirlsChase
//
//  Created by Rapidzz Macbook on 08/04/2019.
//  Copyright © 2019 Rapidzz. All rights reserved.
//

import UIKit

class BarChartCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var youBarViewWidth: NSLayoutConstraint?
    @IBOutlet weak var youBarViewHeight: NSLayoutConstraint?
    @IBOutlet weak var globalBarViewHeight: NSLayoutConstraint?
    
    @IBOutlet weak var viewYouBar: UIView?
    @IBOutlet weak var viewGlobalBar: UIView?
    @IBOutlet weak var lblAge: UILabel?
    
    @IBOutlet weak var numberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewYouBar?.layer.cornerRadius = 3
        self.viewGlobalBar?.layer.cornerRadius = 3
        self.youBarViewHeight?.constant = 170
        self.globalBarViewHeight?.constant = 170
    }
    
    func configureCllHeight(info:GraphStatesViewModel, maxAdminCount:Double, collectIonHeight: Double ) {
        self.numberLabel?.isHidden = true
        self.numberLabel?.text =  String(info.admin)
        
        let h = Double(collectIonHeight*0.7)
        if maxAdminCount > 0 {
        let height = CGFloat(Double(info.admin) / maxAdminCount * (h))
           
            self.youBarViewHeight?.constant = height
        } else {
            self.youBarViewHeight?.constant = 0
        }
        
        let name = Utilities.getShortDayname(info.dayName)
        self.lblAge?.text = name
        
        viewYouBar?.backgroundColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 0.6589821171)
        viewYouBar?.layer.cornerRadius = 2.0

        viewYouBar?.layer.cornerRadius = (viewYouBar?.frame.size.width ?? 10)/2
        viewYouBar?.clipsToBounds = true
    }
    
//    func configureView(index:Int,chart:ChartViewModel)  {
//        //self.youBarViewWidth?.constant = 11
//        if(index == 0){
//            self.lblAge?.text = chart.age
//            self.youBarViewHeight?.constant = CGFloat(chart.you)
//            self.globalBarViewHeight?.constant = CGFloat(chart.global)
//        }else if(index == 1){
//            self.lblAge?.text = chart.age
//            self.youBarViewHeight?.constant = CGFloat(chart.you)
//            self.globalBarViewHeight?.constant = CGFloat(chart.global)
//        }else if(index == 2){
//            self.lblAge?.text = chart.age
//            self.youBarViewWidth?.constant = 0
//            self.youBarViewHeight?.constant = 0
//            self.globalBarViewHeight?.constant = CGFloat(chart.global)
//        }else if(index == 3){
//            self.lblAge?.text = chart.age
//            self.youBarViewWidth?.constant = 0
//            self.youBarViewHeight?.constant = 0
//            self.globalBarViewHeight?.constant = CGFloat(chart.global)
//        }else if(index == 4){
//            self.lblAge?.text = chart.age
//            self.youBarViewWidth?.constant = 0
//            self.youBarViewHeight?.constant = 0
//            self.globalBarViewHeight?.constant = CGFloat(chart.global)
//        }
//        UIView.animate(withDuration: 1) {
//            self.layoutIfNeeded()
//        }
//        
//    }
}
