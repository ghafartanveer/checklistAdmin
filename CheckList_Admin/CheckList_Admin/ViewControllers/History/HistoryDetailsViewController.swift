//
//  HistoryDetailsViewController.swift
//  Checklist_Admin
//
//  Created by Muaaz Ahmad on 5/07/2021.
//

import UIKit

class HistoryDetailsViewController: BaseViewController, TopBarDelegate {
    
//MARK: - Outlets
    @IBOutlet weak var checkInDetailsContainerView: UIView!//

    @IBOutlet weak var teckNameLbl: UILabel!
    @IBOutlet weak var techEmail: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var regNoLbl: UILabel!//
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var createdAtTimeLbl: UILabel!
    
    @IBOutlet weak var categoryNameLbl: UILabel!
    
    @IBOutlet weak var checkInDateLbl: UILabel!
    
    @IBOutlet weak var chckOutDateLbl: UILabel!
    @IBOutlet weak var checkInTimeLbl: UILabel!
    @IBOutlet weak var checkOutTimeLbl: UILabel!
    
    @IBOutlet weak var taskListTableview: UITableView!
    
    
//MARK: - Variables & Objcts
    var historyDetailObject = HistoryTaskViewModel()
    
//MARK: - Overridden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let container = self.mainContainer{
            container.delegate = self
           
            container.setMenuButton(true, title: TitleNames.History)
            //container.viewTopColour.backgroundColor = .white
        }
        layoutSetup()
        setCheckinDetails()
        
    }
    
    //MARK: - Functions
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func layoutSetup() {
        checkInDetailsContainerView.dropShadow(radius: 5, opacity: 0.4)//.addshadow()
    }
    
    func setCheckinDetails() {
       print(historyDetailObject)
        teckNameLbl.text = (historyDetailObject.technician?.firstName ?? "") + " " + (historyDetailObject.technician?.firstName ?? "")
        techEmail.text = historyDetailObject.technician?.email
        customerNameLbl.text = historyDetailObject.activity?.customerName
        regNoLbl.text = historyDetailObject.activity?.registrationNumber
        
        let createdAtDateTime = historyDetailObject.createdAt
        let checkInDateTime = historyDetailObject.activity?.checkIn
        let checkOutDateTime = historyDetailObject.activity?.checkOut
        
        dateLbl.text = Utilities.getDatefromDateString(strDate: checkInDateTime ?? "" , formate: "yyyy-MM-dd")
        
        createdAtTimeLbl.text = Utilities.getTimeFromDateString(strDate: createdAtDateTime ?? "")
        
        checkInTimeLbl.text = Utilities.getTimeFromDateString(strDate: checkInDateTime ?? "", formate: "dd-MM-yyyy HH:mm:ss" ) //00

        checkOutTimeLbl.text = Utilities.getTimeFromDateString(strDate: checkOutDateTime ?? "" , formate: "dd-MM-yyyy HH:mm:ss") //00
        
        checkInDateLbl.text = Utilities.getDatefromDateString(strDate: checkInDateTime ?? "" )
        
        chckOutDateLbl.text = Utilities.getDatefromDateString(strDate: checkOutDateTime ?? "")
        
        categoryNameLbl.text = historyDetailObject.categoryName
    }

}

//MARK: - EXTENISON TABEL VIEW METHODS

extension HistoryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyDetailObject.subcategories?.subCategoryList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.HistoryDetailsTaskListTableViewCell, for: indexPath) as! HistoryDetailsTaskListTableViewCell
        
        let dataAtIndex = historyDetailObject.subcategories?.subCategoryList[indexPath.row]
        
        cell.configureCell(info: dataAtIndex ?? SubcategoryViewModel())
        cell.shaowContainerView.dropShadow()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

