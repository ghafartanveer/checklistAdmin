//
//  BarChartTableViewCell.swift
//  CheckList_Admin
//
//  Created by Rapidzz Macbook on 14/06/2021.
//

import UIKit

class BarChartTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView:UICollectionView?
    @IBOutlet weak var viewBackground:UIView?
    
    var graphviewModel = GraphStatesListViewModel()
    var maxAdminCount = 0.0
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.collectionView?.delegate = self
        self.collectionView?.register(UINib(nibName: CellIdentifier.BarChartCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.BarChartCollectionViewCell)
        self.viewBackground?.dropShadow(radius: 5, opacity: 0.5)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
    func configureCell(info:GraphStatesListViewModel ) {
        self.graphviewModel = info
        let max = graphviewModel.graphList.max { $0.admin < $1.admin }?.admin ?? 0
        maxAdminCount = Double(max)
        self.collectionView?.reloadData()
    }
}
extension BarChartTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.graphviewModel.graphList.count//7//self.chartList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView!.frame.size.width / CGFloat(self.graphviewModel.graphList.count)//7
        let height = self.collectionView!.frame.height
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.BarChartCollectionViewCell, for: indexPath) as! BarChartCollectionViewCell
        cell.configureCllHeight(info: self.graphviewModel.graphList[indexPath.item], maxAdminCount: self.maxAdminCount, collectIonHeight: Double((collectionView.frame.height)))
//        cell.configureView(index: indexPath.row, chart: self.chartList[indexPath.row])
        return cell
    }
}

