//
//  GraphStatesListViewModel.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmad on 06/07/2021.
//

import Foundation

import Foundation
import SwiftyJSON

class GraphStatesListViewModel {
    var graphList:[GraphStatesViewModel]
    
    init() {
        self.graphList = [GraphStatesViewModel]()
    }
    
    convenience init(obj: JSON) {
        self.init()
        
        let dayNameList:[String] = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
        
        for day in dayNameList {
            for (key, value) in obj[0] {
                if key == day{
                let list = GraphStatesViewModel(info: value, dayName: key)
                self.graphList.append(list)
                break
                }
            }
        }    
    }
}
