//
//  TaskCategoryTableViewCell.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 27/04/2021.
//

import UIKit
protocol TaskCategoryTableViewCellDelegate: NSObjectProtocol {
    func callBackMoveOnContoller(index: Int)
}

class TaskCategoryTableViewCell: BaseTableViewCell {
    @IBOutlet weak var viewCollection: UICollectionView!
    
    var statesViewModel = StatesViewModel()
    
    weak var delegate: TaskCategoryTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   

}
//MARK: - EXTENSION COLLECTION VIEW METHODS
extension TaskCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeMenu.MENU_LIST.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.HomeCollectionViewCell, for: indexPath) as! HomeCollectionViewCell
        var recordCount = 0
        if indexPath.row == 0 {
            
            recordCount = statesViewModel.admins
        } else if indexPath.row == 1 {
            recordCount = statesViewModel.technicians
        } else if indexPath.row == 2 {
            recordCount = statesViewModel.checklists
        } else {
            recordCount = statesViewModel.completedTask
        }

        cell.configureMenu(data: HomeMenu.MENU_LIST[indexPath.row], index: indexPath.row, countTxt: recordCount)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collection = collectionView.bounds.width
        return CGSize(width: collection / 2, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.callBackMoveOnContoller(index: indexPath.row)
    }
}
