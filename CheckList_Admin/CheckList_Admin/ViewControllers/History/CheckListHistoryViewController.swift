//
//  CheckListHistoryViewController.swift
//  Checklist_Admin
//
//  Created by Muaaz Ahmad on 5/07/2021.
//

import UIKit

var pdfRecordsList = [HistoryTaskViewModel]()

class CheckListHistoryViewController: BaseViewController, TopBarDelegate {
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var searchBarTF: UITextField!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var generatePdfReport: UIButton!
    
    //MARK: - OBJECT AND VERIABLES
    var historyObject = HistoryTaskListViewModel()
    var filteredObject = [HistoryTaskViewModel]()
    
    
    var isPdf = false
//    var resturantFilterList = [RestaurantViewModel]()
//
//    var resturantObj = ResturantListViewModel()
    
    //MARK: - OVERRIDE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        getHistoryListApi()
        searchBarTF.delegate = self
        
        searchBarTF.addTarget(self, action: #selector(searchHandler(textField:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //tempList()
        
       // generatePdfReport.isHidden = true
        if isPdf {
            generatePdfReport.isHidden = false
        } else {
            generatePdfReport.isHidden = true
        }
        if let container = self.mainContainer{
            container.delegate = self
            
            container.setMenuButton(true, title: TitleNames.History)
            //container.rightBtn.tintColor = .systemPink
            container.setRightBtn(isRightHidden: false, image: UIImage())
            container.rightImagePdfIcon.isHidden = false
            container.rightImagePdfIcon.image = UIImage(named: AssetNames.newPdficon)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let container = self.mainContainer{
        container.rightImagePdfIcon.isHidden = true
        }
            
    }
    
    func tempList() {
        for (i,data) in self.historyObject.historyTaskList.enumerated() {
            pdfRecordsList.append(data)
            if i == 80 {
                break
            }
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
        //:"2021-07-19,2021-07-26
        let today = Utilities.getNextDateString(date: Date(), value: 0)
        let yesterDay = Utilities.getNextDateString(date: Date(), value: -1)
        
        SearchHistoryListApi(params: ["date":yesterDay + "," + today])
        self.alertView?.close()
    }
    
    override func callBackLastWeekPressed() {
        
        let today = Utilities.getNextDateString(date: Date(), value: 0)
        let lastWeek = Utilities.getNextDateString(date: Date(), value: -7)
        let weakFiterdays = Utilities.getLastWeekDates()

        SearchHistoryListApi(params: ["date": weakFiterdays])//lastWeek + "," + today])
        self.alertView?.close()
    }
    
    override func callBackLastMonthPressed() {
        
       // let today = Utilities.getNextDateString(date: Date(), value: 0)
        let lastMonth = Utilities.getDateLastmonthForFilter()//Utilities.getNextDateString(date: Date(), value: -30)
        
        
        SearchHistoryListApi(params: ["date":lastMonth])//lastMonth+","+today])
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
    
    func checkIfAnItemIsSelected() {

        //print(pdfRecordsList.count)

        if pdfRecordsList.count > 0 {
            generatePdfReport.isHidden = false
        } else {
            generatePdfReport.isHidden = true
        }
    }
    
    func navigateToPdfViewer() {
        if let container = self.mainContainer{
            container.rightImagePdfIcon.isHidden = true
        }
        let storyboard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.HistoryPdfGeneratorViewController) as! HistoryPdfGeneratorViewController
       // vc.pdfRecordsList = pdfRecordsList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc final private func searchHandler(textField: UITextField) {
        //print("Text changed", textField.text)
    
        if(textField.text == ""){
            self.historyObject.historyTaskList = self.filteredObject
            self.historyTableView.reloadData()
        }
        else{
            
            let filterdItemsArray = self.filteredObject.filter({
                ((($0.technician?.firstName?.lowercased() ?? "") + " " +  ($0.technician?.lastName?.lowercased() ?? "") ).contains(textField.text!.lowercased()))
                    || ($0.technician?.email?.lowercased().contains(textField.text!.lowercased()))!
            })
            self.historyObject.historyTaskList = filterdItemsArray
            
            self.historyTableView.reloadData()
           // print(filterdItemsArray)
        }
        
            
    }
    
    func actionBack() {
        
        pdfRecordsList.removeAll()
        if Global.shared.isFromNotification{
            if let contianer = self.mainContainer{
                Global.shared.isFromNotification = false
               // Global.shared.notificationId = 0
                contianer.showHomeController()
            }
        }else{
            if let container = self.mainContainer{
                container.rightImagePdfIcon.isHidden = true
            }

            self.loadHomeController()
            //self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func rightButtonAction() {
        if isPdf {
            
        } else {
            isPdf = true
            if pdfRecordsList.count > 0 {
            generatePdfReport.isHidden = false
            }
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
       // print(self.historyObject.historyTaskList.count)
        return self.historyObject.historyTaskList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TaskHistoryTableViewCell) as! TaskHistoryTableViewCell
        cell.cellIndex = indexPath.row
        cell.configureHistoryList(info: self.historyObject.historyTaskList[indexPath.row])
        cell.checkBtn.isHidden = !isPdf
        
        cell.containerView.dropShadow()
        cell.delegate = self
        
        
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
                        if var history = historyInfo{
                            history.historyTaskList.reverse()
                            self.historyObject = history
                            self.filteredObject.removeAll()
                            self.filteredObject.append(contentsOf: self.historyObject.historyTaskList)
                            if historyObject.historyTaskList.count == 0 {
                                historyTableView.setNoDataMessage(LocalStrings.NoDataFound)
                                pdfRecordsList.removeAll()
                                self.historyTableView.reloadData()

                            } else {
                                historyTableView.setNoDataMessage("")
                                self.searchHandler(textField: searchBarTF)
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
                            self.filteredObject.removeAll()
                            self.filteredObject.append(contentsOf: self.historyObject.historyTaskList)
                            if historyObject.historyTaskList.count == 0 {
                                historyTableView.setNoDataMessage(LocalStrings.NoDataFound)
                                self.historyTableView.reloadData()

                            } else {
                                historyTableView.setNoDataMessage("")
                                pdfRecordsList.removeAll()
                                //self.filteredObject.removeAll()

                                self.searchHandler(textField: searchBarTF)
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
            //for (recordId,recod) in pdfRecordsList.enumerated() {
            
            for selectdRecordIndex in 0..<pdfRecordsList.count {
                if pdfRecordsList[selectdRecordIndex].id == self.historyObject.historyTaskList[index].id {
                    pdfRecordsList.remove(at: selectdRecordIndex)
                    break;
                }
            }
            
        } else {
            cell.checkBtn.isSelected = true
            self.historyObject.historyTaskList[index].isSelectedForPdf = true
            pdfRecordsList.append(self.historyObject.historyTaskList[index])
            
        }
        checkIfAnItemIsSelected()
        print(pdfRecordsList.count)

    }
    
    func seeDetilsCallBack(index: Int) {
        if let container = self.mainContainer{
            container.rightImagePdfIcon.isHidden = true
        }
        let storyboard = UIStoryboard(name: StoryboardNames.Home, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.HistoryDetailsViewController) as! HistoryDetailsViewController
        vc.historyDetailObject = self.historyObject.historyTaskList[index]
        self.navigationController?.pushViewController(vc, animated: true)
        
        print("See details of index: ", index)
    }
}
