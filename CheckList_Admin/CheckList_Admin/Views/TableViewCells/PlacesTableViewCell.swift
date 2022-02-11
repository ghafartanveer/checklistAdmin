//
//  PlacesTableViewCell.swift
//  Tawrid
//
//  Created by apple on 3/5/20.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPlace: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureView(place : NSAttributedString){
        self.lblPlace.attributedText = place
    }

}
