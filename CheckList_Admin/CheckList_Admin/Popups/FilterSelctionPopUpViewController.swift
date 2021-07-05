//
//  FilterSelctionPopUpViewController.swift
//  Checklist_Admin
//
//  Created by Muaaz Ahmad on 5/07/2021.
//

import UIKit

protocol FilterSelctionPopUpViewControllerDelegte :NSObjectProtocol {
    func callBackYesterdayPressed()
    func callBackLastWeekPressed()
    func callBackLastMonthPressed()
    func callBackAllListPressed()
}

class FilterSelctionPopUpViewController: BaseViewController {

    //MARK: - OBJECT AND VERIBALES
    weak var delegate: FilterSelctionPopUpViewControllerDelegte?
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - IBActions methods
    
    @IBAction func yesterDayBtn(_ sender: Any) {
        delegate?.callBackYesterdayPressed()
    }
    @IBAction func lastWeakBtn(_ sender: Any) {
        delegate?.callBackLastWeekPressed()
    }
    @IBAction func lastMonth(_ sender: Any) {
        delegate?.callBackLastMonthPressed()
    }
    
    @IBAction func allListBtn(_ sender: Any) {
        delegate?.callBackAllListPressed()
    }
    
    
}
