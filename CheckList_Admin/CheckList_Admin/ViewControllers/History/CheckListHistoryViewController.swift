//
//  CheckListHistoryViewController.swift
//  Checklist_Admin
//
//  Created by Muaaz Ahmad on 5/07/2021.
//

import UIKit

class CheckListHistoryViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var searchBarTF: UITextField!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var generatePdfReport: UIButton!
    
    //MARK: - OBJECT AND VERIABLES
    var historyObject = HistoryTaskListViewModel()
    var filteredObject = [HistoryTaskViewModel]()
    
    var pdfRecordsList = [HistoryTaskViewModel]()
    var isPdf = false
//    var resturantFilterList = [RestaurantViewModel]()
//
//    var resturantObj = ResturantListViewModel()
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHistoryListApi()
        searchBarTF.delegate = self
        
        searchBarTF.addTarget(self, action: #selector(yourHandler(textField:)), for: .editingChanged)

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer{
            container.delegate = self
            
            container.setMenuButton(true, title: TitleNames.History)
            container.setRightBtn(isRightHidden: false, image: UIImage(named: AssetNames.PdfIcon)!)
        
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let container = self.mainContainer{
            container.delegate = self
            
            container.rightBtn.isHidden = true
            //container.viewTopColour.backgroundColor = .white
        }
    }
    override func callBackYesterdayPressed() {
        
        let yesterDay = Utilities.getNextDateString(date: Date(), value: -1)
        
        SearchHistoryListApi(params: ["date":yesterDay])
        self.alertView?.close()
    }
    
    override func callBackLastWeekPressed() {
        
        let today = Utilities.getNextDateString(date: Date(), value: 0)
        let lastWeek = Utilities.getNextDateString(date: Date(), value: -7)

        SearchHistoryListApi(params: ["date":today+","+lastWeek])
        self.alertView?.close()
    }
    
    override func callBackLastMonthPressed() {
        
        let today = Utilities.getNextDateString(date: Date(), value: 0)
        let lastMonth = Utilities.getNextDateString(date: Date(), value: -30)
        
        SearchHistoryListApi(params: ["date":today+","+lastMonth])
        self.alertView?.close()
    }
    
    override func callBackAllListPressed() {
        getHistoryListApi()
        self.alertView?.close()
    }
    
    
    //MARK: - IBACTIONS
    @IBAction func showFilterPopUp(_ sender: Any) {
        showHistorySlectionPopup()
        self.alertView?.show()
    }
    
    @IBAction func generateReportAction(_ sender: Any) {
        navigateToPdfViewer()
    }
    
    
    //MARK: - FUNCTIONS . Search
    
    func navigateToPdfViewer() {
        
        let storyboard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.HistoryPdfGeneratorViewController) as! HistoryPdfGeneratorViewController
        vc.pdfRecordsList = self.pdfRecordsList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc final private func yourHandler(textField: UITextField) {
        print("Text changed", textField.text)
    
        if(textField.text == ""){
            self.historyObject.historyTaskList = self.filteredObject
            self.historyTableView.reloadData()
        }
        else{
            let filterdItemsArray = self.filteredObject.filter({ ($0.activity?.customerName?.lowercased().contains(textField.text!.lowercased()))! || ($0.activity?.registrationNumber?.lowercased().contains(textField.text!.lowercased()))!
            })
            self.historyObject.historyTaskList = filterdItemsArray
            
            self.historyTableView.reloadData()
            print(filterdItemsArray)
        }
        
            
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightButtonAction() {
        if isPdf {
            
        } else {
            isPdf = true
            
        }
        historyTableView.reloadData()
    }
   
//    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
//        let p = longPressGesture.location(in: self.historyTableView)
//        let indexPath = self.historyTableView.indexPathForRow(at: p)
//        if indexPath == nil {
//            print("Long press on table view, not row.")
//        } else if longPressGesture.state == UIGestureRecognizer.State.began {
//            let cell = historyTableView.cellForRow(at: indexPath!) as! WorkListTableViewCell
//            historyTableView.beginUpdates()
//            if cell.isSelected {
//                cell.setSelected(false, animated: true)
//                cell.viewShadow.borderColor = .clear
//                print("Unselected row, at \(indexPath!.row)")
//                if selectedItems.contains(indexPath!.row) {  selectedItems = selectedItems.filter { $0 != indexPath!.row } }
//
//                if !selectedItems.isEmpty {
//                    nextBtn.isHidden = false
//                } else {
//                    nextBtn.isHidden = true
//                }
//            } else {
//                cell.setSelected(true, animated: true)
//                cell.viewShadow.borderWidth = 5
//                cell.viewShadow.borderColor = .gray
//                print("Selected row, at \(indexPath!.row)")
//                if !(selectedItems.contains(indexPath!.row)) { selectedItems.append(indexPath!.row) }
//            }
//            if selectedItems.isEmpty {
//                nextBtn.isHidden = true
//            } else {
//                nextBtn.isHidden = false
//            }
//            historyTableView.endUpdates()
//        }
//    }
}

//MARK: - EXTENISON TABEL VIEW METHODS
extension CheckListHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.historyObject.historyTaskList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TaskHistoryTableViewCell) as! TaskHistoryTableViewCell
        cell.configureHistoryList(info: self.historyObject.historyTaskList[indexPath.row])
        cell.checkBtn.isHidden = !isPdf
        
        cell.containerView.dropShadow()
        cell.delegate = self
        cell.cellIndex = indexPath.row
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("nothing yet")
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

//MARK: - Text field delegate
extension CheckListHistoryViewController : UITextFieldDelegate {
    
    
}

//MARK: - Get task list History
extension CheckListHistoryViewController{
    func getHistoryListApi(){
        self.startActivity()
        GCD.async(.Background) {
            HistoryService.shared().getHistoryApi(params: [:]) { (message, success, historyInfo) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        if let history = historyInfo{
                            
                            self.historyObject = history
                            self.filteredObject.append(contentsOf: self.historyObject.historyTaskList)
                            if historyObject.historyTaskList.count == 0 {
                                historyTableView.setNoDataMessage(LocalStrings.NoDataFound)
                                self.historyTableView.reloadData()

                            } else {
                                historyTableView.setNoDataMessage("")
                            self.historyTableView.reloadData()
                            }
                            
                        }
                        
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    //MARK: - Search task list History
    func SearchHistoryListApi(params: ParamsString){
        self.startActivity()
        GCD.async(.Background) {
            HistoryService.shared().searcHistoryApi(params: params) { (message, success, historyInfo) in
                GCD.async(.Main) { [self] in
                    self.stopActivity()
                    if success{
                        if let history = historyInfo{
                            self.historyObject = history
                            self.filteredObject.append(contentsOf: self.historyObject.historyTaskList)
                            if historyObject.historyTaskList.count == 0 {
                                historyTableView.setNoDataMessage(LocalStrings.NoDataFound)
                                self.historyTableView.reloadData()

                            } else {
                                historyTableView.setNoDataMessage("")
                                self.historyTableView.reloadData()
                            }
                        }
                    }else{
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
}

// MARK: - See details History delegate

extension CheckListHistoryViewController : TaskHistoryTableViewCellDelegate {
    func selectCellHistory(index: Int, cell: TaskHistoryTableViewCell) {
        if cell.checkBtn.isSelected {
            cell.checkBtn.isSelected = false
            self.historyObject.historyTaskList[index].isSelectedForPdf = false
            for recordId in 0..<pdfRecordsList.count-1 {
                if pdfRecordsList[recordId].id == self.historyObject.historyTaskList[index].id {
                    pdfRecordsList.remove(at: recordId)
                }
            }
        
        } else {
            cell.checkBtn.isSelected = true
            self.historyObject.historyTaskList[index].isSelectedForPdf = true
            pdfRecordsList.append(self.historyObject.historyTaskList[index])
            
        }
        
    }
    
    
    func seeDetilsCallBack(index: Int) {
        let storyboard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.HistoryDetailsViewController) as! HistoryDetailsViewController
        vc.historyDetailObject = self.historyObject.historyTaskList[index]
        self.navigationController?.pushViewController(vc, animated: true)
        
        print("See details of index: ", index)
    }
}
