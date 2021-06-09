//
//  StoreListViewModel.swift
//  CheckList_Admin
//
//  Created by Rizwan Ali on 06/05/2021.
//

import Foundation
import SwiftyJSON


class StoreListViewModel {
    
    var storeList: [StoreViewModel]
    
    init() {
        self.storeList = [StoreViewModel]()
    }
    
    convenience init(list: JSON) {
        self.init()
        if let jsonList = list.array{
          let list = jsonList.map({StoreViewModel(obj: $0)})
            self.storeList.append(contentsOf: list)
        }
    }
    
    
    func getStoreDetailAganistID(storeID: Int) -> StoreViewModel{
        var storeDetail = StoreViewModel()
        for each in self.storeList{
            if each.id == storeID{
                storeDetail = each
            }
        }
        return storeDetail
    }
}
