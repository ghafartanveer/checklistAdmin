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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView?.register(UINib(nibName: CellIdentifier.BarChartCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.BarChartCollectionViewCell)
        self.viewBackground?.dropShadow(radius: 5, opacity: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension BarChartTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7//self.chartList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView!.frame.size.width / 7
        return CGSize(width: width, height: self.collectionView!.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.BarChartCollectionViewCell, for: indexPath) as! BarChartCollectionViewCell
//        cell.configureView(index: indexPath.row, chart: self.chartList[indexPath.row])
        return cell
    }
}
